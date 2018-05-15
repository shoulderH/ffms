(function () {
    var TopoCore = function (opt) {
        this.options = {
            deviceIconUrl: 'pages/topo/img/topo/topicon/',
            editModeLinkColor: '152,197,235',
            autoRefresh: true,
            minHeight: 365,
            intervalTime: 5*60*1000 // 5min
        };

        this._element = opt.container;
        this.topoData = opt.data;

        // 视图id
        this.topoViewId;

        this.renderTopo();
    };
    TopoCore.prototype = {

        renderTopo: function () {
            var self = this;
            this.scale = 1; //缩放比例

            // todo
            //this.currentSelectRegion = {id: 3}; //当前选中区域
            this.currentSelectNode; // 当前选中节点
            this.currentSelectLink; // 当前选中连线

            this.nodes = [];//存放节点对象
            this.links = [];//存放连线的象

            this.nodeOccupyInterface = {}; //节点被占用的接口

            // 当前是区域还是拓扑（目前只有两层）
            this.isRegionView = false;

            // 拓扑组件最外围容器
            this.$topoPage = this.findElem('.cwyun-topology-page');
            //
            this.$pageIntro = this.findElem('.page-intro');
            // 拓扑面板容器
            this.$topoBox = $(".topology-box");
            //
            this.$topoOperBox = this.findElem('.topology-operating-box');
            // 节点菜单
            this.$nodeMenu = this.findElem('[name=nodeMenu]');
            // stage菜单
            this.$stageMenu = this.findElem('[name=stageMenu]');
            // link菜单
            this.$linkMenu = this.findElem('[name=linkMenu]');
            // lead头部
            this.$leadUnit = this.findElem('.lead');
            // headbar
            this.$headbar = this.findElem('.topology-headbtn');

            // 编辑状态
            this.editSwitch = !!this.options.isEdit;
            // 直线
            this.addLinkSwitch = false;
            // 拆线
            this.addFoldLinkSwitch = false;

            // init拓扑
            var topology = document.getElementById('topology');
            this.stage = new JTopo.Stage(topology);
            // 拓扑场景
            this.scene = new JTopo.Scene(this.stage);
            // this.scene.visible = false;
            this.stage.eagleEye.visible = false;
            this.stage.wheelZoom = null;
            this.scene.background = '';

            this.canvas = $("#topology"); //变量关联
            this.context = this.canvas.get(0).getContext("2d");

            this.resizeCanvas();
            $(window).resize(function(){
                self.resizeCanvas();
            });

            // 没有事件阻止，有这样一个问题：“右键某个节点，节点菜单出现，但事件继续传递，又立马弹出stage菜单”
            // 人工判断是否右键节点/线
            this.evtCount = 0;

            // 初始化标题头
            this._initHeadbar();

            this._initScene();

            this._bindEvt();
        },

        _initScene: function () {

            var self = this;

            // 默认第一层为区域
            if (this.isRegionView) {
                this.getRegionData();
            } else {
                // 预防需求变动为 直接显示拓扑
                this.getTopoData();
            }

            // 初始化工具栏
            this._initToolbar();

            // 空白处右键菜单
            this.scene.mouseup(function (event) {
                if (!self.editSwitch) {
                    return;
                }
                self.evtCount--;
                if (self.evtCount == 0) {
                    // 说明这个是点击节点事件冒泡的！
                    return;
                }
                if (event.button == 2) {// 右键
                    // 重新计算stage菜单位置
                    var offset = self.getRelativeOffset(event);
                    self.$stageMenu.css(offset);
                    // 显示
                    if(self.options.sceneRight == false){
                        return;
                    }
                    self.$stageMenu.show();
                } else {
                    // 隐藏
                    self.$stageMenu.hide();
                }
                // 关闭节点菜单
                self.$nodeMenu.hide();
                // 关闭连线菜单
                self.$linkMenu.hide();
            });

            this.dynamicAddLink();
        },

        _initHeadbar: function () {
            var self = this;
            var regionName = this.currentSelectRegion ? this.currentSelectRegion.name : '&nbsp;';
            if(this.isRegionView){
                this.$leadUnit.html('<span class="lead-title">设备拓扑结构</span>');
                this.$headbar.hide();
            }else{
                this.$leadUnit.html('<a class="lead-title">设备拓扑结构</a> > <span class="lead-sub-title inline-title-fix" title="'+ regionName +'">'+ regionName +'</span>');
                this.$leadUnit.find('.lead-title').click(function () {
                   // self.toggleScene();
                });
                this.$headbar.show();
            }
        },

        // 支持动态添加连线
        dynamicAddLink: function () {
            var self = this;
            // 编辑状态下线颜色
            var editModeLinkColor = self.options.editModeLinkColor;
            // 添加连线用到的“临时线”
            var beginNode = null;
            var tempNodeA = new JTopo.Node('tempA');
            tempNodeA.setSize(1, 1);
            var tempNodeZ = new JTopo.Node('tempZ');
            tempNodeZ.setSize(1, 1);
            var link = new JTopo.Link(tempNodeA, tempNodeZ);
            var foldLink = new JTopo.FoldLink(tempNodeA, tempNodeZ);
            link.strokeColor = editModeLinkColor;
            foldLink.strokeColor = editModeLinkColor;
            link.manual = 1;
            foldLink.manual = 1;

            this.scene.mouseup(function (evt) {
                if (!self.editSwitch || (!self.addLinkSwitch && !self.addFoldLinkSwitch)) {
                    return;
                }
                // self.addLinkTmp 当用户点击其它区域，删除该连线时引用到
                var linkTmp = self.addLinkTmp = self.addFoldLinkSwitch ? foldLink : link;
                if (evt.button == 2) {
                    self.scene.remove(linkTmp);
                    return;
                }
                if (evt.target != null && evt.target instanceof JTopo.Node) {
                    if (beginNode == null) {
                        // 弹窗选择开始设备接口
                        // self.showInterfaceDialog(evt, function (interfaceItem) {
                            var interfaceItem = {
                                interfaceId: 0,
                                interfaceName: '1'
                            };
                            var interfaceId = interfaceItem.interfaceId,
                                interfaceName = interfaceItem.interfaceName;

                            beginNode = evt.target;
                            // 记录当前选中接口，之后有用
                            beginNode.startInterfaceId = interfaceId;
                            beginNode.startInterfaceName = interfaceName;
                            self.scene.add(linkTmp);
                            tempNodeA.setLocation(evt.x, evt.y);
                            tempNodeZ.setLocation(evt.x, evt.y);
                        // });
                    } else if (beginNode !== evt.target) {
                        // 弹窗选择结束设备接口
                        // self.showInterfaceDialog(evt, function (interfaceItem) {

                            var interfaceItem = {
                                interfaceId: 0,
                                interfaceName: '1'
                            };
                            var interfaceId = interfaceItem.interfaceId,
                                interfaceName = interfaceItem.interfaceName;

                            var endNode = evt.target;
                            var tmpLink = {
                                "id": null,
                                "linkName": null,
                                "aNode": beginNode.nodeId,
                                "zNode": endNode.nodeId,
                                "aIf": beginNode.startInterfaceId,
                                "zIf": interfaceId,
                                "aIfName": beginNode.startInterfaceName,
                                "zIfName": interfaceName,
                                "aIfStatus": null,
                                "zIfStatus": null,
                                "manual": 1,
                                "status": null,
                                "linkType": self.addFoldLinkSwitch ? 'FoldLink' : ''
                            };
                            self.renderLink(tmpLink);

                            // 添加已使用接口
                            self.addOccupyIF(beginNode.nodeId, beginNode.startInterfaceId);
                            self.addOccupyIF(endNode.nodeId, interfaceId);

                            beginNode = null;
                            self.scene.remove(linkTmp);
                        // });
                    } else {
                        beginNode = null;
                    }
                } else {
                    self.scene.remove(linkTmp);
                }
            });
            this.scene.mousedown(function (e) {
                if (!self.editSwitch || (!self.addLinkSwitch && !self.addFoldLinkSwitch)) {
                    return;
                }
                var linkTmp = self.addFoldLinkSwitch ? foldLink : link;
                if (e.target == null || e.target === beginNode || e.target === linkTmp) {
                    self.scene.remove(linkTmp);
                }
            });
            this.scene.mousemove(function (e) {
                if (!self.editSwitch || (!self.addLinkSwitch && !self.addFoldLinkSwitch)) {
                    return;
                }
                tempNodeZ.setLocation(e.x, e.y);
            });
        },

        // 窗口变化画布重绘
        resizeCanvas: function () {
            // 获取容器宽高
            var containerSize = this._getContainerSize();

            // 扣除其余高度
            var headShow = this.$pageIntro.is(':visible');
            var headHight = this.$pageIntro.outerHeight(true);
            var toolShow = this.$topoOperBox.is(':visible');
            var toolHight = this.$topoOperBox.outerHeight(true);
            var otherHeight = headShow ? headHight : 0;
            otherHeight += toolShow ? toolHight : 0;

            // 计算宽/高度
            var responseSize = {
                width: containerSize.width,
                height: containerSize.height - otherHeight
            };

            // 设置网格div宽高
            this.$topoBox.css('height', responseSize.height);

            // 设置canvas宽高
            this.canvas.attr("width", responseSize.width);
            this.canvas.attr("height", responseSize.height);
            this.context.fillRect(0, 0, this.canvas.width(), this.canvas.height());
        },

        // 占用指定节点的指定接口
        addOccupyIF: function (nodeId, interfaceId) {
            var tmpList = this.nodeOccupyInterface[nodeId];
            tmpList || (tmpList = this.nodeOccupyInterface[nodeId] = []);
            tmpList.push(interfaceId)
        },

        // 释放指定节点的指定接口
        delOccupyIF: function (nodeId, interfaceId) {
            var tmpList = this.nodeOccupyInterface[nodeId];
            if (tmpList) {
                var j = tmpList.indexOf(interfaceId);
                j != -1 && tmpList.splice(j, 1);
            }
        },

        // 刷新区域
        refreshRegion: function () {
            // 还原画布初始位置
            this.resetOffsetScale();

            this.cleanTopology();

            // 刷新数据
            this.getRegionData();
        },

        // 初始化工具栏
        _initToolbar: function () {
            this.toggleToolbar();
        },

        // 切换工具栏
        toggleToolbar: function () {
            if (this.isRegionView) {
                this.$topoOperBox.hide();
            } else {
                this.$topoOperBox.show();
                // 重置编辑状态
                this.editSwitch = !this.options.isEdit;
                this.toggleEdit();
            }
        },

        // 绑定事件
        _bindEvt: function () {
            var self = this;
            // 自动刷新
            this._element.find('.switchRadio').on('click',function (evt) {
                $(this).toggleClass("on");
                self.toggleAutoRefresh();
            });
            // 标题返回区域
            this._element.find('a.lead-title').on('click',function (evt) {
                self.toggleScene();
            });
            // 返回区域
            this._element.find('[name=returnRegion]').click(function () {
                if(self.editSwitch){
                    self.showConfirm({
                        message: "尚未保存编辑动作，确定返回区域？",
                        handle: function () {
                            self.toggleScene();
                        }
                    })
                }else{
                    self.toggleScene();
                }
            });
            // 全屏
            this._element.find('[name=fullScreen]').click(function () {
                self._runPrefixMethod(self.stage.canvas, "RequestFullScreen");
            });
            // 居中适应画布
            this._element.find('[name=centerAndZoom]').click(function (evt) {
                self.stage.centerAndZoom();
            });
            // 还原尺寸
            this._element.find('[name=restoreSize]').click(function (evt) {
                self.scene.scaleX = 1;
                self.scene.scaleY = 1;
            });
            // 创建容器
            this._element.find('[name=createContainer]').click(function (evt) {
                // self.stage.mode = 'select';

            });
            // 节点右键菜单
            this.$nodeMenu.find('a').click(function () {
                var action = $(this).attr('type');
                if (action == 'rename') {
                    self.renameNode();
                } else if (action == 'change') {
                    self.changeNodeType();
                } else if (action == 'delete') {
                    self.deleteNode();
                } else if (action == 'edit') {
                    self.editNode();
                }
                self.$nodeMenu.hide();
            });
            // 连线右键菜单
            this.$linkMenu.find('a').click(function () {
                var action = $(this).attr('type');
                if (action == 'delete') {
                    self.deleteLink();
                }
                self.$linkMenu.hide();
            });
            // stage右键菜单（即空白处右键）
            this.$stageMenu.find('a').click(function (evt) {
                var action = $(this).attr('type');
                if (action == 'addNode') {
                    self.addNewNode(evt);
                } else if (action == 'addContainer') {
                    self.addContainer(evt);
                }
                self.$stageMenu.hide();
            });
            // 编辑
            this._element.find('[name=edit]').click(function () {
                self.cleanTopoStatus();
                self.toggleEdit();
            });
            // 取消编辑
            this._element.find('[name=cancleedit]').click(function () {
                self.showConfirm({
                    message: "确定要取消么？",
                    handle: function () {
                        self.toggleEdit();
                        self.refreshTopology();
                    }
                });
            });
            // 开启/关闭添加直线
            this._element.find('[name=switchAddLink]').click(function (evt) {
                self.addLinkSwitch = !self.addLinkSwitch;
                if(self.addLinkSwitch){
                    $(this).addClass('selected');
                    // 直线与拆线互斥
                    self.addFoldLinkSwitch = false;
                    self._element.find('[name=switchAddFoldLink]').removeClass('selected');
                }else{
                    $(this).removeClass('selected');
                }
            });
            // 开启/关闭添加折线
            this._element.find('[name=switchAddFoldLink]').click(function (evt) {
                self.addFoldLinkSwitch = !self.addFoldLinkSwitch;
                if(self.addFoldLinkSwitch){
                    $(this).addClass('selected');
                    // 直线与拆线互斥
                    self.addLinkSwitch = false;
                    self._element.find('[name=switchAddLink]').removeClass('selected');
                }else{
                    $(this).removeClass('selected');
                }
            });
            // 刷新
            $('#refresh').click(function (event) {
                if (self.isRegionView) {
                    // 刷新区域
                    self.refreshRegion();
                } else {
                    // 刷新拓扑
                    self.refreshTopology();
                }
            });
            // 保存拓扑
            this._element.find('[name=saveTopo]').click(function () {
                self.showConfirm({
                    message: "确定保存操作？",
                    handle: function () {
                        // 加工数据
                        var nodes = self.nodes;
                        var links = self.links;

                        var params = {
                            nodes: [],
                            links: []
                        };

                        nodes.forEach(function (item, index) {
                            params.nodes.push({
                                nodeName: item.text,
                                status: '',
                                nodeType: item.nodeType,
                                areaId: self.currentSelectRegion.id,
                                groupId: null,
                                mapLabel: null,
                                manual: item.manual,
                                id: '',
                                nodeId: item.nodeId,
                                x: item.x + self.scene.translateX,
                                y: item.y + self.scene.translateY
                            });
                        });
                        links.forEach(function (item, index) {
                            params.links.push({
                                "id": item.linkId,
                                "linkName": null,
                                "aNode": item.aNode,
                                "zNode": item.zNode,
                                "aIf": item.aIf,
                                "zIf": item.zIf,
                                "aIfName": item.aIfName,
                                "zIfName": item.zIfName,
                                "aIfStatus": '',
                                "zIfStatus": '',
                                "manual": item.manual,
                                "status": ''
                            });
                        });
                        self.fetch({
                            method: 'post',
                            url: 'topo/save',
                            isJsonObj: true,
                            params: {
                                mapId: self.currentSelectRegion.id,
                                jsonStr: JSON.stringify(params)
                            }
                        }).then(function (response) {
                            if(response && response.successed){
                                self.showMyToaster("success", "保存成功！");
                                self.toggleEdit();
                                self.refreshTopology();
                            }else{
                                self.showMyToaster("error", "保存失败！");
                            }
                        });
                    },
                    cancel: function () {

                    }
                });
            });
            // 同步请求
            this._element.find('[name=syncData]').click(function (event) {
                self.showConfirm({
                    message: "确定要同步么？",
                    handle: function () {
                        self.fetch({
                            url: 'topo/refresh'
                        }).then(function (response) {
                            if(response.successed){
                                self.showMyToaster("success", "同步成功！");
                                self.refreshTopology();
                            }else{
                                this.showMyToaster("error", "同步失败！");
                            }
                        });
                    },
                    cancel: function () {

                    }
                });
            });
            this.findElem('[name=addRelation]').click(function (evt) {
                self.addRelation(evt);
            });
        },

        // 删除添加连线过程中意外中止的过程线
        _deleteUnexpectedLink: function (evt) {
            if(evt.target != this.canvas[0]){
                if(this.addLinkTmp){
                    this.scene.remove(this.addLinkTmp);
                    this.addLinkTmp = null;
                }
            }
        },

        // 清除拓扑状态
        cleanTopoStatus: function () {
            var self = this;
            this.nodes.forEach(function (item, index) {
                self.cleanNodeStatus(item);
            });
            this.links.forEach(function (item, index) {
                self.cleanLinkStatus(item);
            })
        },

        // 清除节点状态
        cleanNodeStatus: function (item) {
            item.setImage(this.options.deviceIconUrl + item.nodeType.toLowerCase() + ".png", true);
        },

        // 清除连线状态
        cleanLinkStatus: function (item) {
            item.strokeColor = this.options.editModeLinkColor;
        },

        //
        _runPrefixMethod: function(element, method) {
            var usablePrefixMethod;
            ["webkit", "moz", "ms", "o", ""].forEach(function(prefix) {
                    if (usablePrefixMethod) return;
                    if (prefix === "") {
                        // 无前缀，方法首字母小写
                        method = method.slice(0,1).toLowerCase() + method.slice(1);
                    }
                    var typePrefixMethod = typeof element[prefix + method];
                    if (typePrefixMethod + "" !== "undefined") {
                        if (typePrefixMethod === "function") {
                            usablePrefixMethod = element[prefix + method]();
                        } else {
                            usablePrefixMethod = element[prefix + method];
                        }
                    }
                }
            );
            return usablePrefixMethod;
        },
        
        // 切换场景
        toggleScene: function () {
            // 重置视图
            this.resetOffsetScale();
            //
            if (this.isRegionView) {
                // 显示拓扑
                this.isRegionView = false;
                // this.stage.eagleEye.update();
            } else {
                // 显示区域
                this.isRegionView = true;
                // this.scene.visible = false;
                // this.stage.eagleEye.update();
            }
            // 重新渲染lead头
            this._initHeadbar();
            // 切换工具栏
            this.toggleToolbar();
            // 刷新视图
            this.refreshView();
        },

        // 重置偏移缩放
        resetOffsetScale: function () {
            // 重置偏移量
            this.scene.translateX = 0;
            this.scene.translateY = 0;
            // 还原1:1
            this.scene.scaleX = 1;
            this.scene.scaleY = 1;
        },

        refreshView: function () {
            if (this.isRegionView) {
                // 刷新区域
                this.refreshRegion();
            } else {
                // 刷新拓扑
                this.refreshTopology();
            }
        },

        handleRegion: function (data) {
            var self = this;
            if (!data || !data.length) {
                return;
            }
            data.forEach(function (item, index) {
                var node = new JTopo.Node(item.name);
                node.textPosition = "Middle_Center";
                node.regionId = item.id;
                node.regionName = item.name;
                node.borderRadius = 6;
                // 大小尺寸、图片啥的。。
                node.setSize(60, 56);
                node.font = '14px 微软雅黑';
                node.fontColor = '134,228,255';
                node.setImage(self.options.deviceIconUrl + 'area.png', true);
                node.dbclick(function (evt) {
                    // 记录选中区域id
                    self.currentSelectRegion = {
                        id: evt.target.regionId,
                        name: evt.target.regionName
                    };
                    // 切换场景，显示该区域下的拓扑图
                    self.toggleScene();
                });
                // 场景、容器均要添加
                self.scene.add(node);
            });
        },

        getRegionData: function () {
        },

        // 获取容器宽高
        _getContainerSize: function () {
            var $topoContainer = this.getDom().parent();
            var width = $topoContainer.width(),
                height = $topoContainer.height();
            return {
                width: width,
                height: height
            }
        },

        // 弹出接口列表
        showInterfaceDialog: function (evt, callback) {
            var self = this;
            // 获取该节点设备接口
            var currentNode = evt.target;
            var occupyIFList = this.nodeOccupyInterface[currentNode.nodeId] || [];
            this.fetch({
                url: 'topo/ifs',
                params: {
                    nodeId: currentNode.nodeId
                }
            }).then(function (response) {
                var availableIFList = [];
                var data = response;
                // 过滤已用接口
                data.forEach(function (item, index) {
                    if (occupyIFList.indexOf(item.id.toString()) == -1) {
                        availableIFList.push(item);
                    }
                });
                // 弹窗
                self.showDialog({
                    title: '接口选择',
                    shadeClose: true,
                    width: 250,
                    buttons: null,
                    position: [evt.pageX, evt.pageY],
                    template: '<div>hello</div>'
                });
            });
        },


        // 获取节点对应图片
        _getIcon: function (type) {
            if(type) {
                return type.toLowerCase() + '.png';
            }
        },

        // 编辑节点
        editNode: function () {
            var self = this;
            this.showDialog({
                winId: 'editNodeWinId',
                data: this.currentSelectNode,
                title: '编辑节点',
                width: '550px',
                templateUrl: basePath.VIEW_PATH + "business/itportal/views/topo/editNode.html",
                controller: 'topo.editNode.ctrl as editNode',
                saveCallBack: function () {
                    var newName = $('#editNodeDiv').scope().editNode.save();
                    self.currentSelectNode.text = newName;
                    $('#editNodeWinId').widget().destroy();
                }
            })
        },

        // 删除选中节点
        deleteNode: function () {
            var self = this;
            var currentNodeId = this.currentSelectNode.name.split('node')[1];
            var currentNodeName = this.currentSelectNode.text;
            this.showConfirm({
                message: "确定删除节点 " + currentNodeName + " ?",
                handle: function () {
                    self.deleteNodeFun(self.currentSelectNode);
                },
                cancel: function () {

                }
            });
        },

        // 本地删除节点
        deleteNodeFun: function (node) {
            var self = this;
            var j;
            // 删除相关连线
            var linkList = node.outLinks || [];
            linkList = linkList.concat(node.inLinks || []);
            linkList.forEach(function (item, index) {
                j = self.links.indexOf(item);
                self.scene.remove(item);
                j != -1 && self.links.splice(j, 1);
            });
            // 删除节点
            self.scene.remove(node);
            j = self.nodes.indexOf(node);
            j != -1 && self.nodes.splice(j, 1);
        },

        renderNode: function (node) {
            if(!node){
                return;
            }
            var self = this;
            var nodeType = node.nodeType;
            var nodeTmp = new JTopo.Node();
            nodeTmp.tip = node.nodeId + "_" + node.nodeId + "-" + node.nodeType;
            nodeTmp.name = 'node' + node.nodeId;
            nodeTmp.nodeId = node.nodeId;
            nodeTmp.manual = node.manual;
            this.editSwitch || (nodeTmp.dragable = false);
            nodeTmp.fontColor = '134,228,255';
            nodeTmp.font = '14px 微软雅黑';
            nodeTmp.nodeType = nodeType;
            nodeTmp.setImage(this.options.deviceIconUrl + self._getIcon(node.nodeType), true);
            nodeTmp.text = node.nodeName;
            nodeTmp.showSelected = false;
            nodeTmp.paintAlarmText = function(a) {
            if (null != this.alarm && "" != this.alarm) {
                var b = this.alarmColor || "255,0,0",
                    c = this.alarmAlpha || .5;
                a.beginPath(),
                a.font = this.alarmFont || "12px 微软雅黑";

                var textArray = this.alarm.split('\n');
                var rowCnt = textArray.length;
                var i = 0, maxLength = 0, maxText = textArray[0];
                for(;i<rowCnt;i++){
                     var nowText = textArray[i],textLength = nowText.length;
                     if(textLength >=maxLength){
                         maxLength = textLength;
                         maxText = nowText;
                     }
                }
                var maxWidth = a.measureText(maxText).width;
                var lineHeight = 16; // 字体大小 + 6
                // alarm框的宽度
                var d =( (a.measureText(this.alarm).width/rowCnt +6) > maxWidth? (a.measureText(this.alarm).width) : maxWidth);
                var e =(lineHeight)*(rowCnt), // alarm 框高度 行高*行数
                    f = this.width / 2 - d / 2 , // alarm 框横向位置
                    g = - this.height /2  - e - 20; // alarm 纵横向位置
//
                //绘制alarm框
                a.top = "30px";
                a.strokeStyle = "rgba(" + b + ", " + c + ")",
                a.fillStyle = "rgba(" + b + ", " + c + ")",
                a.lineCap = "round",
                a.lineWidth = 1,
                a.moveTo(f -10, g - 10), // 左上  这些10是调整 alarm 边框离文字的距离
                a.lineTo(f + d +10, g - 10), // 右上
                a.lineTo(f + d +10, g + e + 10), // 右下
                a.lineTo(f + d / 2 + 6, g + e  + 10),
                a.lineTo(f + d / 2, g + e + 8  + 10),
                a.lineTo(f + d / 2 - 6, g + e  + 10),
                a.lineTo(f - 10, g + e  + 10), // 左下
                a.lineTo(f -10, g -10),
                a.fill(),
                a.stroke(),
                a.closePath(),
                a.beginPath(),
                a.strokeStyle = "rgba(" + this.fontColor + ", " + this.alpha + ")",
                a.fillStyle = "rgba(" + this.fontColor + ", " + this.alpha + ")",
                (function(a,b,x,y,textArray){
                     for(var j= 0;j<textArray.length;j++){
                         var words = textArray[j];
                         a.fillText(words,x ,y);
                         y+= lineHeight;
                     }
                })(a,this,f,g+8,textArray),
                a.closePath()
            }
        };
            var message;
            var status;
//            if(parseInt(node.netId)!=0){
//            	$.ajax({
//                	type : "GET",
//            		url : ctx + "/topologyController.do?getNodeStatus&nodeId="+node.netId,
//            		contentType : "application/x-www-form-urlencoded; charset=utf-8",
//            		dataType : "json",
//            		success : function(result) {
//            			if(result[0].status){
//                			node.status = result[0].status;
//                			message = result[0].message;
//            			}
//            		},
//                });
//            }
//            nodeTmp.setLocation(node.x * this.scale, node.y * this.scale);
//            nodeTmp.mouseover(function(evt){
//            	if(message){
//            		if(node.nodeIP){
//            			this.alarm = "告警信息："+message+"\n管理  IP:"+node.nodeIP;
//            		}else{
//            			this.alarm = "告警信息："+message;
//            		}
//            	}else{
//            		if(node.nodeIP){
//            			this.alarm="名称: " + node.nodeName+"\n管理  IP:"+node.nodeIP;
//            		}else if(node.nodeName != ''){
//            			this.alarm="名称: " + node.nodeName;
//            		}
//            		
//            	}
//                this.alarmColor = '0,0,0';
//                this.alarmHeadColor = '65,153,240';
//                self.stickNode(node.nodeId);
//               // self.topoNodeToolTipHandler(evt, nodeTmp);
//                
//            });
            nodeTmp.mouseout(function(evt){
                self.topoNodeOutHandler(evt);
                this.alarm='';
            });
            nodeTmp.dbclick(function(){});
            nodeTmp.mouseup(function(event){self.nodeMouseUp(event, nodeTmp)});
            self.nodes.push(nodeTmp);
            self.scene.add(nodeTmp);
            self.setNodeAlarm(nodeTmp, node.status);
        },

        renderNodeList: function (nodeList) {
            if (nodeList != undefined && nodeList.length > 0) {
                for (var i = 0; i < nodeList.length; i++) {
                    this.renderNode(nodeList[i]);
                }
            }
        },

//        renderLink: function (link) {
//            if(!link){
//                return;
//            }
//            var self = this;
//            var beginNode = this._getNodeById(link.aNode);
//            var endNode = this._getNodeById(link.zNode);
//            var linkTmp = link.linkType == 'FoldLink' ? new JTopo.FoldLink(beginNode, endNode) : new JTopo.Link(beginNode, endNode);
//            linkTmp.tip = link.id + "_" + link.aNode + "-" + link.zNode;
//
//            // 保存节点属性
//            linkTmp.linkId = link.id;
//            linkTmp.text = link.linkName;
//            linkTmp.textOffsetY = 25;
//            // linkTmp.textOffsetX = -25;
//            linkTmp.aNode = link.aNode;
//            linkTmp.zNode = link.zNode;
//            linkTmp.aIf = link.aIf;
//            linkTmp.zIf = link.zIf;
//            linkTmp.aIfName = link.aIfName;
//            linkTmp.zIfName = link.zIfName;
//            linkTmp.manual = link.manual;
//
//            // 连线样式
//            this.options.linkArrow && (linkTmp.arrowsRadius = 10);
//            linkTmp.strokeColor = this.options.editModeLinkColor;
//            linkTmp.lineWidth = 1;
//            linkTmp.showSelected = false;
//            linkTmp.fontColor = self.colorRgb('#666');
//            linkTmp.font = '14px 微软雅黑';
//
//            linkTmp.mouseover(function(){self.showLinkTooltip(this);});
//            linkTmp.mouseout(function(){self.hideLinkTooltip();});
//            linkTmp.dbclick(function(){self.sendRuquestToLink(link.connectionId + "','" + link.connectionName)})
//            linkTmp.mouseup(function(event){self.linkRightMenuFn(event,  linkTmp)});
//
//            self.links.push(linkTmp);
//            self.scene.add(linkTmp);
//            if(linkTmp.aIf>0 && linkTmp.zIf>0){
//            	$.ajax({
//                	type : "GET",
//            		url : ctx + "/topologyController.do?getLinkStatus&aIf="+linkTmp.aIf+"&zIf="+linkTmp.zIf,
//            		contentType : "application/x-www-form-urlencoded; charset=utf-8",
//            		dataType : "json",
//            		success : function(result) {
//            			link.status = parseInt(result);
//            		},
//                });
//            }
//            self.setLinkAlarm(linkTmp, link.status)
//        },

        renderLinkList: function (linkList) {
            if (linkList != undefined && linkList.length > 0) {
                for (var i = 0; i < linkList.length; i++) {
                    this.renderLink(linkList[i]);
                }
            }
        },

        // 显示连线tooltip
        showLinkTooltip: function () {
            this._element.find('[name=linkToolTip]').hide();
        },

        // 隐藏连线tooltip
        hideLinkTooltip: function () {

        },

        // 根据实体id获取节点
        _getNodeById: function (id) {
            for(var i=0; i<this.nodes.length; i++){
                var node = this.nodes[i];
                if(node.nodeId == id){
                    return node;
                }
            }
        },

        // 显示节点tooltip
        topoNodeToolTipHandler: function (evt, node) {
/*        	var self = this;
            var $nodeToolTip = self.findElem('[name=nodeToolTip]');
            $nodeToolTip.empty();
            $nodeToolTip.append('<div>hello world 添加自己的tooltip</div>');
                
            // 防止跑出屏蔽外
            var isFixed = 1;
            var viewWidth = document.documentElement.clientWidth + (isFixed ? 0 : $(document).scrollLeft());
            var viewHeight = document.documentElement.clientHeight + (isFixed ? 0 : $(document).scrollTop());
            // tooltip信息窗的宽、高
            var ifSelectDivWidth = $nodeToolTip.width();
            var ifSelectDivHeight = $nodeToolTip.height();
            var judgeWidth = 0;
            var judgeHeight = 0;
            var pageY = self.$topoBox.offset().top + node.y + self.scene.translateY;
            var pageX = self.$topoBox.offset().left + node.x + self.scene.translateX + node.width;

            if(pageY + ifSelectDivHeight > viewHeight){
                judgeHeight = ifSelectDivHeight;
            }
            if(pageX + ifSelectDivWidth > viewWidth){
                judgeWidth = ifSelectDivWidth;
            }
            // 定位显示
            var offset = {
                top: node.y + self.scene.translateY - judgeHeight,
                left: node.x + self.scene.translateX + (judgeWidth ? -judgeWidth : node.width)
            };
            $nodeToolTip.css({
                top: offset.top,
                left: offset.left
            }).show();*/
        },

        // 离开节点隐藏tooltip
        topoNodeOutHandler: function (evt) {
            this._element.find(".nodeToolTip").hide()
        },

        // 获取点击事件的相对位置（相对浏览器窗口）
        getRelativeOffset: function (evt) {
            return {
                top: evt.pageY - this.$topoBox.offset().top,
                left: evt.pageX - this.$topoBox.offset().left
            }
        },

        // 连线右键
        linkRightMenuFn: function (event, link) {
            if(this.options.linkRight == false){
                return;
            }
            if (!this.editSwitch) {
                return;
            }
            if (event.button == 2) {// 右键
                this.currentSelectLink = link;
                // 当前位置弹出菜单（div）
                var offset = this.getRelativeOffset(event);
                this.$linkMenu.css(offset).show();
                // 隐藏stage菜单
                this.$stageMenu.hide();
                // 隐藏节点菜单
                this.$nodeMenu.hide();
                // event.stopPropagation();
                // jtopo阻止事件传递怎么做啊。。。上面这句报错
                this.evtCount = 1;
            }
        },

        // 节点鼠标离开事件
        nodeMouseUp: function (event, node) {
            if(node.disableRight){
                return;
            }
            var self = this;
            if(this.options.nodeRight == false){
                return;
            }
            if(this.options.nodeRight){
                var actionItem = this.$nodeMenu.find('a');
                actionItem.each(function (index, item) {
                    self.options.nodeRight.indexOf($(item).attr('type')) == -1 && $(item).parent().remove();
                })
            }
            if (!this.editSwitch) {
                return;
            }
            if (event.button == 2) {// 右键
                this.currentSelectNode = node;
                // 当前位置弹出菜单（div）
                var offset = this.getRelativeOffset(event);
                this.$nodeMenu.css(offset).show();
                // 隐藏stage菜单
                this.$stageMenu.hide();
                // 隐藏连线菜单
                this.$linkMenu.hide();
                // event.stopPropagation();
                // jtopo阻止事件传递怎么做啊。。。上面这句报错
                this.evtCount = 1;
            }
            // 判断是否进入容器区域
            // if(){
            //
            // }
        },

        //跳转到连线对应的NNM页面
        sendRuquestToLink: function (connectionId, connectionName) {
            // var connectionFlag = 1;
            // if(connectionId == ""){
            // 	alert("该链路为外联链路");
            // }else{
            // 	_jumpNnmDetailPage(connectionId,connectionName,connectionFlag);
            // }
        },

        setNodeImage: function (nodeType, i) {
            if (nodeType) {
                this.nodes[i].setImage(this.options.deviceIconUrl+ nodeType.toLowerCase() + ".png", true);
            }
        },

        // 设置节点告警
        setNodeAlarm: function (node, status) {
            var alarmIndex;
            // 后端状态：    0 正常，1 未知，2 轻微，3 警告，4 重大，5 严重
            // UI图片编号：  0 未知，1 正常，2 轻微，3 警告，4 重大，5 严重
            switch (status){
                case 0:
                    alarmIndex = 0;
                    break;
                case 1:
                    alarmIndex = 1;
                    break;
                case 2:
                    alarmIndex = 2;
                    break;
                case 3:
                    alarmIndex = 3;
                    break;
                case 4:
                    alarmIndex = 4;
                    break;     
                case 5:
                    alarmIndex = 5;
                    break;
                default:
                    alarmIndex = status;
            }
            
            var imageName = node.nodeType.toLowerCase() + '-' + alarmIndex + '.png';
            node.setImage(this.options.deviceIconUrl + imageName, true);
        },

        // 设置连线告警
        setLinkAlarm: function (link, status) {
            var color;
            switch (status){
                case 0:
                    // 0 正常【绿#32b16c】，
                    color = this.colorRgb('#32b16c');
                    break;
                case 1:
                    // 1 未知【灰#c9c9c9】，
                    color = this.colorRgb('#c9c9c9');
                    break;
                case 2:
                    // 2 轻微【黄#ffe010】，
                    color = this.colorRgb('#ffe010');
                    break;
                case 3:
                    // 3 警告【蓝#00b7ee】，
                    color = this.colorRgb('#00b7ee');
                    break;
                case 4:
                    // 4 重大【橙#f19149】，
                    color = this.colorRgb('#f19149');
                    break;
                case 5:
                    // 5 严重【红#ff2637】
                    color = this.colorRgb('#ff2637');
                    break;
                default:
                    // 未知【灰#c9c9c9】
                    color = this.colorRgb('#c9c9c9');
            }
            link.strokeColor = color;
        },

        //置顶节点对象，解决zIndex覆盖问题（也就是后面添加的节点会遮盖前面添加的节点）【直观的看，tooltip会被遮住】
        stickNode: function (id) {
            for (var j = 0; j < this.nodes.length; j++) {
                if (this.nodes[j].tip.substr(0, this.nodes[j].tip.indexOf('_')) == id) {
                    this.scene.stick(this.nodes[j]);
                    break;
                }
            }
        },

        // 获取拓扑数据
        getTopoData: function () {
            if(!this.topoData){
                return;
            }
            this.handleTopo(this.topoData);
        },

        getNodes: function () {
            return this.nodes || [];
        },

        getLinks: function () {
            return this.links || [];
        },

        handleTopo: function (data) {
            var self = this;
            self.renderNodeList(data.nodes);
            self.renderLinkList(data.links);
        },

        // 更新刷新时间及重置定时器
        updateRefreshInterval: function () {
            this.findElem('[name=refreshTime]').html(''/*moment().format('YYYY-MM-DD HH:mm:ss')*/);
            this._clearTimer();
            this._addTimer();
        },

        // 清除定时器
        _clearTimer: function () {
            this.refreshInterval && clearInterval(this.refreshInterval);
        },

        // 添加定时器
        _addTimer: function () {
            /*var self = this;
            self.refreshInterval = setInterval(function () {
                // 未开启自动刷新 或 编辑状态，均不让刷新
                if(!self.options.autoRefresh || self.options.editSwitch){
                    return;
                }
                self.refreshTopology();
            }, this.options.intervalTime)*/
        },

        // 切换自动刷新
        toggleAutoRefresh: function () {
            this.options.autoRefresh = !this.options.autoRefresh;
        },

        // 渲染节点状态
        renderNodeAlarm: function (statusItem) {
            for(var i = 0; i < this.nodes.length; i++) {
                var node = this.nodes[i];
                if(statusItem.nodeId == node.nodeId){
                    this.setNodeAlarm(node, statusItem.eStatus);
                    break;
                }
            }
        },

        // 渲染连线状态
        renderLinkAlarm: function (statusItem) {
            for(var i = 0; i < this.links.length; i++) {
                var link = this.links[i];
                if(statusItem.linkId == link.linkId){
                    this.setLinkAlarm(link, statusItem.lStatus);
                    break;
                }
            }
        },

        // 清空拓扑（及还原相关数据）
        cleanTopology: function () {
            // 清空
            this.scene.clear();
            this.nodes = [];
            this.links = [];

            // 清空被占用的设备接口
            this.nodeOccupyInterface = {};
        },

        // 刷新当前拓扑
        refreshTopology: function () {
            // 还原画布初始位置
            this.resetOffsetScale();

            this.cleanTopology();

            // 获取后台数据
            this.getTopoData();
        },

        // 切换编辑开关
        toggleEdit: function () {
            this.editSwitch = !this.editSwitch;

            if (this.editSwitch) {
                // 隐藏编辑按钮
                this._element.find('[name=edit]').hide();
                // 显示拓扑编辑工具
                this._element.find('.edit-tool').show();
                // 禁用同步数据
                this._element.find('[name=syncData]').addClass('disabled');
            } else {
                // 显示编辑按钮
                this._element.find('[name=edit]').show();
                // 隐藏拓扑编辑工具
                this._element.find('.edit-tool').hide();
                // 启用同步数据
                this._element.find('[name=syncData]').removeClass('disabled');
            }
            // 显示/隐藏工具条
            // this.editSwitch ? $('.func-option').show() : $('.func-option').hide();
            // 节点拖拽事件还要自己开/关。。没想好
            this.availableDragNode(this.editSwitch);
        },

        // 开启/关闭节点拖拽功能
        availableDragNode: function (switchFlag) {
            this.scene.childs.forEach(function (item, index) {
                if (item.elementType == 'node') {
                    item.dragable = switchFlag;
                }
            })
        },

        // 全自动布局
        autoLayout: function (type) {
            type = (type || 'tree');
            // 目前只支持树型自动布局（官方自带的）
            if(type == 'tree'){
                this.autoTreeLayout();
            }
        },

        // 树型自动布局
        autoTreeLayout: function () {
            this.scene.doLayout(JTopo.layout.TreeLayout('down', 200, 120));
        },

        findElem: function (str) {
            return this._element.find(str);
        },

        getDom: function () {
            return this._element;
        },

        //
        setData: function (data) {
            if(!data){
                return;
            }
            this.topoData = data;
            this.refreshView();
        },

        /**
         * 工具方法
         */
        // 16进制转rgb，eg: #C9C9C9 => 201,201,201
        colorRgb: function (color) {
            var sColor = color.toLowerCase();
            //十六进制颜色值的正则表达式
            var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
            // 如果是16进制颜色
            if (sColor && reg.test(sColor)) {
                if (sColor.length === 4) {
                    var sColorNew = "#";
                    for (var i = 1; i < 4; i += 1) {
                        sColorNew += sColor.slice(i, i + 1).concat(sColor.slice(i, i + 1));
                    }
                    sColor = sColorNew;
                }
                //处理六位的颜色值
                var sColorChange = [];
                for (var i = 1; i < 7; i += 2) {
                    sColorChange.push(parseInt("0x" + sColor.slice(i, i + 2)));
                }
                return sColorChange.join(",");
            }
            return sColor;
        },
        // toaster提示
        showMyToaster: function (type, msg) {
            var tipMessage = this.tipMessage || (this.tipMessage = this.getService('tipMessage'));
            tipMessage.alert(type, msg);
        },
        // 确认框
        showConfirm: function (obj) {
            var message = this.message || (this.message = this.getService('message'));
            this.message.confirmMsgBox({
                content: obj.message,
                callback: function () {
                    obj.handle();
                }
            });
        },
        // 弹窗
        showDialog: function (cfg) {
            var dialog = this.dialog || (this.dialog = this.getService('dialog'));
            dialog.show(cfg);
        },

        destroy: function () {
            this._clearTimer();
            this.close();
            $(document).unbind("click", this._deleteUnexpectedLink);
            this._super();
        }
    };
    window.TopoCore = TopoCore;
})();
