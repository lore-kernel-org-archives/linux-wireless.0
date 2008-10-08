Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:10379 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbYJHJS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 05:18:28 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3907534wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2008 02:18:27 -0700 (PDT)
Message-ID: <eb3ff54b0810080218j4b335ccfy74b6df5e8c7cbba0@mail.gmail.com> (sfid-20081008_111843_786975_5527D25F)
Date: Wed, 8 Oct 2008 11:18:27 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH ] mac80211: use HWSIM_STA_MAGIC in hwsim_check_sta_magic() and hwsim_set_sta_magic().
Cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_88508_14603620.1223457507860"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_88508_14603620.1223457507860
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch (wireless-next-2.6) fixes a typo in mac80211_hwsim.c:
use HWSIM_STA_MAGIC in hwsim_check_sta_magic() and hwsim_set_sta_magic()
instead of HWSIM_VIF_MAGIC.


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_88508_14603620.1223457507860
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fm1qypew0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hYzgwMjExX2h3c2ltLmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9tYWM4MDIxMV9od3NpbS5jCmluZGV4IGM5ZTRhNDMuLmJkNmUyNjUg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hYzgwMjExX2h3c2ltLmMKKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFjODAyMTFfaHdzaW0uYwpAQCAtNjMsMTMgKzYzLDEzIEBA
IHN0cnVjdCBod3NpbV9zdGFfcHJpdiB7CiBzdGF0aWMgaW5saW5lIHZvaWQgaHdzaW1fY2hlY2tf
c3RhX21hZ2ljKHN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEpCiB7CiAJc3RydWN0IGh3c2ltX3N0
YV9wcml2ICpzcCA9ICh2b2lkICopc3RhLT5kcnZfcHJpdjsKLQlXQVJOX09OKHNwLT5tYWdpYyAh
PSBIV1NJTV9WSUZfTUFHSUMpOworCVdBUk5fT04oc3AtPm1hZ2ljICE9IEhXU0lNX1NUQV9NQUdJ
Qyk7CiB9CiAKIHN0YXRpYyBpbmxpbmUgdm9pZCBod3NpbV9zZXRfc3RhX21hZ2ljKHN0cnVjdCBp
ZWVlODAyMTFfc3RhICpzdGEpCiB7CiAJc3RydWN0IGh3c2ltX3N0YV9wcml2ICpzcCA9ICh2b2lk
ICopc3RhLT5kcnZfcHJpdjsKLQlzcC0+bWFnaWMgPSBIV1NJTV9WSUZfTUFHSUM7CisJc3AtPm1h
Z2ljID0gSFdTSU1fU1RBX01BR0lDOwogfQogCiBzdGF0aWMgaW5saW5lIHZvaWQgaHdzaW1fY2xl
YXJfc3RhX21hZ2ljKHN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEpCg==
------=_Part_88508_14603620.1223457507860--
