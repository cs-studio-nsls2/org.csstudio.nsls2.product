#!/bin/bash
set -e

# Check parameters
VERSION=$1
PUSH=$2
BUILD_DIR="build"
if [ $# != 2 ]
then 
  echo You must provide the product version, compat link, milestone, notes \(e.g. \"prepare_release.sh 3.3.0 \"https://github\" \"https://github\" \"Some notes\"\"\)
exit -1
fi

echo ::: Updating plugin versions ::
mvn -Dtycho.mode=maven org.eclipse.tycho:tycho-versions-plugin:0.20.0:set-version -DnewVersion=$VERSION -Dartifacts=nsls2-product,products-csstudio-nsls2-features,org.csstudio.nsls2.product.feature,nsls2-repository
# update product because set-version doesn't
sed -i 's/\(\<product[^>]\+\? version=\"\)[^"]*\("[^>]\+\?>\)/\1'${VERSION}'\2/g'  repository/css-nsls2.product

echo ::: Committing and tagging version $VERSION :::
git commit -a -m "Updating manifests to version $VERSION"
if [ "$PUSH" = "true" ]
then
  echo ::: Tagging version $VERSION :::
  git tag CSS-$VERSION
  echo ::: Pushing changes :::
  git push origin
  git push origin CSS-$VERSION
fi
