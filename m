Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:50471 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYGXHki (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 03:40:38 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3275953wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 00:40:37 -0700 (PDT)
Message-ID: <eb3ff54b0807240040p73253d42vec5ff82504cbffdd@mail.gmail.com> (sfid-20080724_094059_145782_04B10446)
Date: Thu, 24 Jul 2008 10:40:37 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 1/1] mac80211: replace MAC80211_VERBOSE_PS_DEBUG with CONFIG_MAC80211_VERBOSE_PS_DEBUG in net/mac80211/tx.c.
Cc: tomas.winkler@intel.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_981_26112877.1216885237637"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_981_26112877.1216885237637
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

In net/mac80211/tx.c, there are some #ifdef which checks
MAC80211_VERBOSE_PS_DEBUG
(which in fact is never set) instead of
CONFIG_MAC80211_VERBOSE_PS_DEBUG, as should be.

This patch replaces MAC80211_VERBOSE_PS_DEBUG with
CONFIG_MAC80211_VERBOSE_PS_DEBUG in these #ifdef commands in
net/mac80211/tx.c.

(for wireless-next-2.6 tree)

Regards,
Rami Rosen

Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_981_26112877.1216885237637
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fj11wvyy0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS90eC5jIGIvbmV0L21hYzgwMjExL3R4LmMKaW5kZXgg
MGZiYWRkOC4uYTJkZGMwMyAxMDA2NDQKLS0tIGEvbmV0L21hYzgwMjExL3R4LmMKKysrIGIvbmV0
L21hYzgwMjExL3R4LmMKQEAgLTMwNSw3ICszMDUsNyBAQCBzdGF0aWMgdm9pZCBwdXJnZV9vbGRf
cHNfYnVmZmVycyhzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsICpsb2NhbCkKIAlyY3VfcmVhZF91bmxv
Y2soKTsKIAogCWxvY2FsLT50b3RhbF9wc19idWZmZXJlZCA9IHRvdGFsOwotI2lmZGVmIE1BQzgw
MjExX1ZFUkJPU0VfUFNfREVCVUcKKyNpZmRlZiBDT05GSUdfTUFDODAyMTFfVkVSQk9TRV9QU19E
RUJVRwogCXByaW50ayhLRVJOX0RFQlVHICIlczogUFMgYnVmZmVycyBmdWxsIC0gcHVyZ2VkICVk
IGZyYW1lc1xuIiwKIAkgICAgICAgd2lwaHlfbmFtZShsb2NhbC0+aHcud2lwaHkpLCBwdXJnZWQp
OwogI2VuZGlmCkBAIC0zNDIsNyArMzQyLDcgQEAgaWVlZTgwMjExX3R4X2hfbXVsdGljYXN0X3Bz
X2J1ZihzdHJ1Y3QgaWVlZTgwMjExX3R4X2RhdGEgKnR4KQogCQkJcHVyZ2Vfb2xkX3BzX2J1ZmZl
cnModHgtPmxvY2FsKTsKIAkJaWYgKHNrYl9xdWV1ZV9sZW4oJnR4LT5zZGF0YS0+YnNzLT5wc19i
Y19idWYpID49CiAJCSAgICBBUF9NQVhfQkNfQlVGRkVSKSB7Ci0jaWZkZWYgTUFDODAyMTFfVkVS
Qk9TRV9QU19ERUJVRworI2lmZGVmIENPTkZJR19NQUM4MDIxMV9WRVJCT1NFX1BTX0RFQlVHCiAJ
CQlpZiAobmV0X3JhdGVsaW1pdCgpKSB7CiAJCQkJcHJpbnRrKEtFUk5fREVCVUcgIiVzOiBCQyBU
WCBidWZmZXIgZnVsbCAtICIKIAkJCQkgICAgICAgImRyb3BwaW5nIHRoZSBvbGRlc3QgZnJhbWVc
biIsCkBAIC0zODksNyArMzg5LDcgQEAgaWVlZTgwMjExX3R4X2hfdW5pY2FzdF9wc19idWYoc3Ry
dWN0IGllZWU4MDIxMV90eF9kYXRhICp0eCkKIAkJCXB1cmdlX29sZF9wc19idWZmZXJzKHR4LT5s
b2NhbCk7CiAJCWlmIChza2JfcXVldWVfbGVuKCZzdGEtPnBzX3R4X2J1ZikgPj0gU1RBX01BWF9U
WF9CVUZGRVIpIHsKIAkJCXN0cnVjdCBza19idWZmICpvbGQgPSBza2JfZGVxdWV1ZSgmc3RhLT5w
c190eF9idWYpOwotI2lmZGVmIE1BQzgwMjExX1ZFUkJPU0VfUFNfREVCVUcKKyNpZmRlZiBDT05G
SUdfTUFDODAyMTFfVkVSQk9TRV9QU19ERUJVRwogCQkJaWYgKG5ldF9yYXRlbGltaXQoKSkgewog
CQkJCXByaW50ayhLRVJOX0RFQlVHICIlczogU1RBICVzIFRYICIKIAkJCQkgICAgICAgImJ1ZmZl
ciBmdWxsIC0gZHJvcHBpbmcgb2xkZXN0IGZyYW1lXG4iLAo=
------=_Part_981_26112877.1216885237637--
