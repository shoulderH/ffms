/**
 * 
 */
package com.finance.test;

import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @author HZX
 *
 */
/**
 * descrption: spring-test的基类，这样就可以很方便的进行测试Spring-IOC容器里面的Bean了
 *  
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={
        "classpath:applicationContext.xml"})
public class JUnitServiceBase extends AbstractJUnit4SpringContextTests {

}
