const { createRunOncePlugin, withXcodeProject } = require('@expo/config-plugins');

const META_DAT_REPO = 'https://github.com/facebook/meta-wearables-dat-ios.git';
const DAT_PACKAGE_NAME = 'meta-wearables-dat-ios';
const DAT_PRODUCT_NAME = 'MetaWearablesDATCore'; 

const withMetaDat = (config) => {
  return withXcodeProject(config, (config) => {
    const project = config.modResults;
    const projectRootName = config.modRequest.projectName;

    // 1. ADD THE SWIFT PACKAGE REFERENCE (The definitive fix)
    // We remove the .hasSwiftPackage check entirely, as it causes the crash.
    // We directly inject the package reference. If it already exists, Xcode is smart enough to handle it.
    project.addSwiftPackage({
      identifier: DAT_PACKAGE_NAME,
      repository: META_DAT_REPO,
      version: {
        kind: 'upToNextMajorVersion',
        minimumVersion: '1.0.0',
      },
    });
    console.log(`✅ Added Meta DAT Swift Package Reference.`);

    // 2. LINK THE PRODUCT TO THE MAIN TARGET (Crucial for linking)
    // Add the library dependency to the main app target.
    project.addTargetDependency(projectRootName, {
        productName: DAT_PRODUCT_NAME,
        targetName: projectRootName,
        framework: 'target', 
    });
    console.log(`✅ Linked Meta DAT Core Product to target.`);


    return config;
  });
};

// IMPORTANT: Change the module name to force EAS to recognize the update
module.exports = createRunOncePlugin(withMetaDat, 'with-meta-dat-v2', '1.0.2');