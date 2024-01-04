oc annotate routes lb50 haproxy.router.openshift.io/disable_cookies='true'
oc annotate routes lb50 haproxy.router.openshift.io/balance='roundrobin'
