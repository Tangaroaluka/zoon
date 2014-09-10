context('Most functions NOT including main workflow function.')

# CheckModStructure tests

test_that('CheckModStructure works', {
  expect_that(CheckModStructure('XXXX'), equals(list(module='XXXX', paras=list())))
  expect_that(CheckModStructure(CheckModStructure('XXX')), equals(CheckModStructure('XXX')))
})


# CheckModList tests

test_that('CheckModList works.', {
	a <- 'mod'
	b <- ModuleOptions('mod', para='pm')
  c <- list('mod1', 'mod2')
	d <- list(ModuleOptions('mod', para='pm'), 'mod2')
	e <- list(ModuleOptions('mod1', para='pm'), ModuleOptions('mod2', para='pm'))

	expect_true(all(sapply(CheckModList(a), function(l) names(l) == c('module', 'paras'))))
	expect_true(all(sapply(CheckModList(b), function(l) names(l) == c('module', 'paras'))))
	expect_true(all(sapply(CheckModList(c), function(l) names(l) == c('module', 'paras'))))
	expect_true(all(sapply(CheckModList(d), function(l) names(l) == c('module', 'paras'))))
	expect_true(all(sapply(CheckModList(e), function(l) names(l) == c('module', 'paras'))))

	expect_equal(length(CheckModList(a)), 1)
	expect_equal(length(CheckModList(b)), 1)
	expect_equal(length(CheckModList(c)), 2)
	expect_equal(length(CheckModList(d)), 2)
	expect_equal(length(CheckModList(e)), 2)


})



test_that('GetModule works', {
  # Create local module in working directory to test load.
  write('#test file for zoon package\n TestModule <- function(){z <- 2}', file = 'TestModule.R')
  file <- paste0(getwd(), '/TestModule.R')


  TestWorkflow <- function(){
    GetModule(file)
    return(class(TestModule))
  }

  TestModuleName <- function(){
    GetModule('NoProcess', 'Process')
    return(class(NoProcess))
  }


  TestURL <- function(){
    GetModule('https://raw.githubusercontent.com/zoonproject/modules/master/R/Process/NoProcess.R')
    return(class(NoProcess))
  }

  expect_error(GetModule('xxx'))
  expect_that(GetModule(file), equals('TestModule'))
  expect_that(GetModule('NoProcess', 'Process'), equals('NoProcess'))
  expect_that(GetModule('https://raw.githubusercontent.com/zoonproject/modules/master/R/Process/NoProcess.R'), equals('NoProcess'))
  
   #It's difficult to test that the environments are working correctly without running full workflow
  work1 <- workflow(occurMod = 'UKAnophelesPlumbeus',
                 covarMod = 'UKAir',
                 procMod = 'OneHundredBackground',
                 modelMod = 'LogisticRegression',
                 outMod = 'SameTimePlaceMap')
  expect_false(exists('OneHundredBackground', env = globalenv()))
  expect_false(exists('SameTimePlaceMap', env = globalenv()))
  file.remove('TestModule.R')
})





test_that('Module Options tests', {
  
  options <- ModuleOptions('ANamedModule', para1 = 2, para2 = 'AValue')
  optList <- list(module = 'ANamedModule', paras=list(para1 = 2, para2 = 'AValue'))
  
  AModule <- function(){ x <- 2 }
  
  expect_identical(ModuleOptions('ANamedModule'), list(module='ANamedModule', paras=list()))
  expect_identical(options, optList)
  expect_error(ModuleOptions('ANamedModule', 2, 'AValue'))
  expect_error(ModuleOptions(234))
  expect_error(ModuleOptions(AModule))
})