tidb_stable_version="v4.0"
operator_stable_version="v1.1"
dm_stable_version="v1.0"
tidb_in_kubernetes=(stable v1.0 dev)
tidb_data_migration=(stable dev)
ecoSys_docs_type=(tidb-in-kubernetes tidb-data-migration)

cn_tmp_docs_path="content/docs-cn"
en_tmp_docs_path="content/docs"
stable_version_tag="stable"
index_file="_index.md"

mv $en_tmp_docs_path/$tidb_stable_version $en_tmp_docs_path/$stable_version_tag
mv $cn_tmp_docs_path/$tidb_stable_version $cn_tmp_docs_path/$stable_version_tag

cp $en_tmp_docs_path/$stable_version_tag/$index_file $en_tmp_docs_path/
cp $cn_tmp_docs_path/$stable_version_tag/$index_file $cn_tmp_docs_path/

mv $en_tmp_docs_path/tidb-in-kubernetes/v1.1 $en_tmp_docs_path/tidb-in-kubernetes/stable
mv $en_tmp_docs_path/tidb-data-migration/v1.0 $en_tmp_docs_path/tidb-data-migration/stable

for docs_type in "${ecoSys_docs_type[@]}"
do
    type_vers="${docs_type//-/_}"
    versions=${type_vers}[@]
    for v in "${!versions}"
    do
        # make directory for docs_cn and move files from docs_en to docs_cn
        mkdir -p $cn_tmp_docs_path/$docs_type/$v
        mv $en_tmp_docs_path/$docs_type/$v/zh/* $cn_tmp_docs_path/$docs_type/$v/
        mv $en_tmp_docs_path/$docs_type/$v/en/* $en_tmp_docs_path/$docs_type/$v/

        # move files from subdirecotry to parent directory
        find $en_tmp_docs_path/$docs_type/$v -name '*.md' -mindepth 2 -type f -exec mv {} $en_tmp_docs_path/$docs_type/$v \;
        find $cn_tmp_docs_path/$docs_type/$v -name '*.md' -mindepth 2 -type f -exec mv {} $cn_tmp_docs_path/$docs_type/$v \;
        des_toc_file=$(echo data/docs-$docs_type-"${v//./}"-toc.json)
        des_toc_file_cn=$(echo data/docs-cn-$docs_type-"${v//./}"-toc.json)
        prefix=$(echo /docs/$docs_type/$v/)
        prefix_cn=$(echo /docs-cn/$docs_type/$v/)
        node scripts/gen-nav.js $(echo $en_tmp_docs_path/$docs_type/$v/TOC.md) $(echo ${des_toc_file//-/_}) $(echo $prefix) 'basename'
        node scripts/gen-nav.js $(echo $cn_tmp_docs_path/$docs_type/$v/TOC.md) $(echo ${des_toc_file_cn//-/_}) $(echo $prefix_cn) 'basename'
    done
done


cp $en_tmp_docs_path/tidb-in-kubernetes/$stable_version_tag/$index_file $en_tmp_docs_path/tidb-in-kubernetes/
cp $cn_tmp_docs_path/tidb-in-kubernetes/$stable_version_tag/$index_file $cn_tmp_docs_path/tidb-in-kubernetes/

cp $en_tmp_docs_path/tidb-data-migration/$stable_version_tag/$index_file $en_tmp_docs_path/tidb-data-migration/
cp $cn_tmp_docs_path/tidb-data-migration/$stable_version_tag/$index_file $cn_tmp_docs_path/tidb-data-migration/


node scripts/gen-nav.js 'content/docs/stable/TOC.md' 'data/docs_tidb_stable_toc.json' '/docs/stable' 'fullpath'
node scripts/gen-nav.js 'content/docs/dev/TOC.md' 'data/docs_tidb_dev_toc.json' '/docs/dev' 'fullpath'
node scripts/gen-nav.js 'content/docs/v2.1/TOC.md' 'data/docs_tidb_v21_toc.json' '/docs/v2.1' 'fullpath'
node scripts/gen-nav.js 'content/docs/v3.1/TOC.md' 'data/docs_tidb_v31_toc.json' '/docs/v3.1' 'fullpath'
node scripts/gen-nav.js 'content/docs/v3.0/TOC.md' 'data/docs_tidb_v30_toc.json' '/docs/v3.0' 'fullpath'
node scripts/gen-nav.js 'content/docs-cn/stable/TOC.md' 'data/docs_cn_tidb_stable_toc.json' '/docs-cn/stable' 'fullpath'
node scripts/gen-nav.js 'content/docs-cn/dev/TOC.md' 'data/docs_cn_tidb_dev_toc.json' '/docs-cn/dev' 'fullpath'
node scripts/gen-nav.js 'content/docs-cn/v2.1/TOC.md' 'data/docs_cn_tidb_v21_toc.json' '/docs-cn/v2.1' 'fullpath'
node scripts/gen-nav.js 'content/docs-cn/v3.1/TOC.md' 'data/docs_cn_tidb_v31_toc.json' '/docs-cn/v3.1' 'fullpath'
node scripts/gen-nav.js 'content/docs-cn/v3.0/TOC.md' 'data/docs_cn_tidb_v30_toc.json' '/docs-cn/v3.0' 'fullpath'
node scripts/gen-nav.js 'content/about-cn/recruit/TOC.md' 'data/recruit_cn_toc.json' '/about-cn/recruit/' 'fullpath'
node scripts/gen-nav.js 'content/blog-cn/TOC-User-Case.md' 'data/cases_cn_toc.json' '/cases-cn/' 'fullpath'
node scripts/gen-nav.js 'content/tidb-academy/README.md' 'data/tidb_academy_toc.json' '/tidb-academy/' 'fullpath'
