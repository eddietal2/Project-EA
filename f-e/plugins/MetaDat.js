const { createRunOncePlugin, withXcodeProject } = require('@expo/config-plugins');

const META_DAT_REPO = 'https://github.com/facebook/meta-wearables-dat-ios.git';
const DAT_PACKAGE_NAME = 'meta-wearables-dat-ios';
const DAT_PRODUCT_NAME = 'MetaWearablesDATCore';

const withMetaDat = (config) => {
  return withXcodeProject(config, (config) => {
    const project = config.modResults;
    const projectRootName = config.modRequest.projectName;

    // 1. ADD THE SWIFT PACKAGE REFERENCE (The fix for the TypeError)
    // We rely on 'addSwiftPackage' which is the officially supported way to inject the reference.
    if (!project.hasSwiftPackage(DAT_PACKAGE_NAME)) { // We will attempt to use hasSwiftPackage, but if it fails, the next line will create the package.
      project.addSwiftPackage({
        identifier: DAT_PACKAGE_NAME,
        repository: META_DAT_REPO,
        version: {
          kind: 'upToNextMajorVersion',
          minimumVersion: '1.0.0', // Assuming initial release version
        },
      });
      console.log(`✅ Added Meta DAT Swift Package Reference.`);
    }

    // 2. LINK THE PRODUCT TO THE MAIN TARGET (Crucial for linking)
    // We must manually link the library to the app target so the compiler can find it.
    project.addTargetDependency(projectRootName, {
        productName: DAT_PRODUCT_NAME,
        targetName: projectRootName,
        framework: 'target', // The package is added as a framework/library to the target
        // Setting `linkType: 'swiftPackage'` is not available here, so we rely on the target dependency.
    });
    console.log(`✅ Linked Meta DAT Core Product to target.`);


    return config;
  });
};

module.exports = createRunOncePlugin(withMetaDat, 'with-meta-dat', '1.0.1');