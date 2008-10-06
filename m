Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:58918 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYJFN6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 09:58:14 -0400
Received: by yx-out-2324.google.com with SMTP id 8so417230yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 06:58:13 -0700 (PDT)
Message-ID: <eb3ff54b0810060658p2241a6d0k9c6f504d976e0f@mail.gmail.com> (sfid-20081006_155816_959290_E8A6BE2B)
Date: Mon, 6 Oct 2008 15:58:12 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 1/2] iwlwifi: fix compliation warning in iwl-agn-rs.c when CONFIG_IWLWIFI_DEBUG is not set.
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_55851_11422655.1223301492818"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_55851_11422655.1223301492818
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

When CONFIG_IWLWIFI_DEBUG is not set and CONFIG_IWLWIFI is set,
we get this compilation warning:
/wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-agn-rs.c: In
function 'rs_free_sta':
/wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-agn-rs.c:2425:
warning: unused variable 'priv'

This patch (against wireless-next-2.6 tree) fixes it.


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_55851_11422655.1223301492818
Content-Type: text/plain; name=patch1.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flz63y1y0
Content-Disposition: attachment; filename=patch1.txt

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi1ycy5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXJzLmMKaW5kZXggOTM5NDRkZS4u
MWVkNDM5NyAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWdu
LXJzLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXJzLmMKQEAg
LTI0MjIsMTEgKzI0MjIsMTUgQEAgc3RhdGljIHZvaWQgcnNfZnJlZV9zdGEodm9pZCAqcHJpdl9y
LCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhLAogCQkJdm9pZCAqcHJpdl9zdGEpCiB7CiAJc3Ry
dWN0IGl3bF9scV9zdGEgKmxxX3N0YSA9IHByaXZfc3RhOworI2lmZGVmIENPTkZJR19JV0xXSUZJ
X0RFQlVHCiAJc3RydWN0IGl3bF9wcml2ICpwcml2ID0gcHJpdl9yOwogCiAJSVdMX0RFQlVHX1JB
VEUoImVudGVyXG4iKTsKKyNlbmRpZiAvKiBDT05GSUdfSVdMV0lGSV9ERUJVRyAqLwkKIAlrZnJl
ZShscV9zdGEpOworI2lmZGVmIENPTkZJR19JV0xXSUZJX0RFQlVHCQogCUlXTF9ERUJVR19SQVRF
KCJsZWF2ZVxuIik7CisjZW5kaWYgLyogQ09ORklHX0lXTFdJRklfREVCVUcgKi8KIH0KIAogCg==

------=_Part_55851_11422655.1223301492818--
