Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:2597 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYADFDV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 00:03:21 -0500
Received: by wa-out-1112.google.com with SMTP id v27so10211029wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2008 21:03:20 -0800 (PST)
Message-ID: <cb0375e10801032103j2af2acd4heff9ad0adc1038d1@mail.gmail.com> (sfid-20080104_050332_003980_6860FAC4)
Date: Thu, 3 Jan 2008 21:03:19 -0800
From: "Andrew Lutomirski" <andy@luto.us>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] Return an error when SIWRATE doesn't match any rate
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_4147_33370190.1199422999884"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_4147_33370190.1199422999884
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[Attached b/c my mailer will screw it up]

Currently mac80211 fails silently when trying to set a nonexistent
rate.  Return an error instead.

Signed-Off-By: Andy Lutomirski <luto@myrealbox.com>

------=_Part_4147_33370190.1199422999884
Content-Type: text/x-patch; name=mac80211_rate_1.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fb09hafb0
Content-Disposition: attachment; filename=mac80211_rate_1.patch

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9pZWVlODAyMTFfaW9jdGwuYyBiL25ldC9tYWM4MDIx
MS9pZWVlODAyMTFfaW9jdGwuYwppbmRleCBiZTgwZjQ0Li44NDkwZGNhIDEwMDY0NAotLS0gYS9u
ZXQvbWFjODAyMTEvaWVlZTgwMjExX2lvY3RsLmMKKysrIGIvbmV0L21hYzgwMjExL2llZWU4MDIx
MV9pb2N0bC5jCkBAIC01ODEsNyArNTgxLDcgQEAgc3RhdGljIGludCBpZWVlODAyMTFfaW9jdGxf
c2l3cmF0ZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LAogCXNkYXRhLT5ic3MtPmZvcmNlX3VuaWNh
c3RfcmF0ZWlkeCA9IC0xOwogCWlmIChyYXRlLT52YWx1ZSA8IDApCiAJCXJldHVybiAwOwotCWZv
ciAoaT0wOyBpPCBtb2RlLT5udW1fcmF0ZXM7IGkrKykgeworCWZvciAoaT0wOyBpIDwgbW9kZS0+
bnVtX3JhdGVzOyBpKyspIHsKIAkJc3RydWN0IGllZWU4MDIxMV9yYXRlICpyYXRlcyA9ICZtb2Rl
LT5yYXRlc1tpXTsKIAkJaW50IHRoaXNfcmF0ZSA9IHJhdGVzLT5yYXRlOwogCkBAIC01ODksMTAg
KzU4OSwxMCBAQCBzdGF0aWMgaW50IGllZWU4MDIxMV9pb2N0bF9zaXdyYXRlKHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYsCiAJCQlzZGF0YS0+YnNzLT5tYXhfcmF0ZWN0cmxfcmF0ZWlkeCA9IGk7CiAJ
CQlpZiAocmF0ZS0+Zml4ZWQpCiAJCQkJc2RhdGEtPmJzcy0+Zm9yY2VfdW5pY2FzdF9yYXRlaWR4
ID0gaTsKLQkJCWJyZWFrOworCQkJcmV0dXJuIDA7CiAJCX0KIAl9Ci0JcmV0dXJuIDA7CisJcmV0
dXJuIC1FSU5WQUw7CiB9CiAKIHN0YXRpYyBpbnQgaWVlZTgwMjExX2lvY3RsX2dpd3JhdGUoc3Ry
dWN0IG5ldF9kZXZpY2UgKmRldiwK
------=_Part_4147_33370190.1199422999884--
