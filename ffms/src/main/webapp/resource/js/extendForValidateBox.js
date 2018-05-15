$.extend($.fn.validatebox.defaults.rules, {
		idcard: {  
            validator: function(value, param) {  
                return idCardNoUtil.checkIdCardNo(value);  
            },  
            message: '请输入正确的身份证号码'  
        },  
        checkNum: {  
            validator: function(value, param) {  
                return /^([0-9]+)$/.test(value);  
            },  
            message: '请输入整数'  
        },  
        checkFloat: {  
            validator: function(value, param) {  
                return /^[+|-]?([0-9]+\.[0-9]+)|[0-9]+$/.test(value);  
            },  
            message: '请输入合法数字'  
        }
	});