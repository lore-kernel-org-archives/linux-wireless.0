Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.235]:28540 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbYJGO3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 10:29:12 -0400
Received: by wx-out-0506.google.com with SMTP id h27so743491wxd.4
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2008 07:29:11 -0700 (PDT)
Message-ID: <eb3ff54b0810070729s678796a6hb9df7875b99e7a03@mail.gmail.com> (sfid-20081007_162917_194540_4C125B10)
Date: Tue, 7 Oct 2008 16:29:11 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH ] mac80211: remove unused declaration of struct sta_attribute.
Cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_76179_10057561.1223389751239"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_76179_10057561.1223389751239
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch removes unused definition of struct sta_attribute
in net/mac80211/ieee80211_i.h. (for the wireless-next-2.6 tree).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_76179_10057561.1223389751239
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fm0mm8ou0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9pZWVlODAyMTFfaS5oIGIvbmV0L21hYzgwMjExL2ll
ZWU4MDIxMV9pLmgKaW5kZXggODAyNWIyOS4uZDgxNzcyNSAxMDA2NDQKLS0tIGEvbmV0L21hYzgw
MjExL2llZWU4MDIxMV9pLmgKKysrIGIvbmV0L21hYzgwMjExL2llZWU4MDIxMV9pLmgKQEAgLTg3
MSwxMSArODcxLDYgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3QgaWVlZTgwMjExX2h3ICpsb2NhbF90
b19odygKIAlyZXR1cm4gJmxvY2FsLT5odzsKIH0KIAotc3RydWN0IHN0YV9hdHRyaWJ1dGUgewot
CXN0cnVjdCBhdHRyaWJ1dGUgYXR0cjsKLQlzc2l6ZV90ICgqc2hvdykoY29uc3Qgc3RydWN0IHN0
YV9pbmZvICosIGNoYXIgKmJ1Zik7Ci0Jc3NpemVfdCAoKnN0b3JlKShzdHJ1Y3Qgc3RhX2luZm8g
KiwgY29uc3QgY2hhciAqYnVmLCBzaXplX3QgY291bnQpOwotfTsKIAogc3RhdGljIGlubGluZSBp
bnQgaWVlZTgwMjExX2Jzc2lkX21hdGNoKGNvbnN0IHU4ICpyYWRkciwgY29uc3QgdTggKmFkZHIp
CiB7Cg==
------=_Part_76179_10057561.1223389751239--
