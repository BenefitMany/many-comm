task :set_bundle_build_config do
  command "bundle config build.pg --with-pg-config='/usr/pgsql-11/bin/pg_config'"
end
