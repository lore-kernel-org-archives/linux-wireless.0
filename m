Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45561 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951Ab1FWTvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 15:51:37 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so1472543fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 12:51:36 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Jun 2011 15:51:36 -0400
Message-ID: <BANLkTik+Ewz7MV2Lbg9zO+70oPJePDqGCg@mail.gmail.com> (sfid-20110623_215141_691284_1752A119)
Subject: When on a fixed channel in monitor mode, return what that fixed
 channel is.
From: Nicholas Hockey <nhockey@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174735daaf712904a66669b0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0015174735daaf712904a66669b0
Content-Type: text/plain; charset=UTF-8

i was directed this way from the ubuntu kernel mailing list. When on a
fixed channel in monitor mode, the kernel does not return the current
channel, this should fix that.


-- 
Nicholas (Tilt) Hockey

--0015174735daaf712904a66669b0
Content-Type: text/x-patch; charset=US-ASCII; name="monitor-mode-channel.patch"
Content-Disposition: attachment; filename="monitor-mode-channel.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gpa4ma7j0

ZGlmZiAtLWdpdCBhL25ldC93aXJlbGVzcy9jaGFuLmMgYi9uZXQvd2lyZWxlc3MvY2hhbi5jCmlu
ZGV4IDE3Y2QwYzAuLjI2MWVlMzIgMTAwNjQ0Ci0tLSBhL25ldC93aXJlbGVzcy9jaGFuLmMKKysr
IGIvbmV0L3dpcmVsZXNzL2NoYW4uYwpAQCAtODIsMTAgKzgyLDEyIEBAIGludCBjZmc4MDIxMV9z
ZXRfZnJlcShzdHJ1Y3QgY2ZnODAyMTFfcmVnaXN0ZXJlZF9kZXZpY2UgKnJkZXYsCiB7CiAJc3Ry
dWN0IGllZWU4MDIxMV9jaGFubmVsICpjaGFuOwogCWludCByZXN1bHQ7CisgICAgc3RydWN0IHdp
cmVsZXNzX2RldiAqbW9uX2RldiA9IE5VTEw7CiAKLQlpZiAod2RldiAmJiB3ZGV2LT5pZnR5cGUg
PT0gTkw4MDIxMV9JRlRZUEVfTU9OSVRPUikKKwlpZiAod2RldiAmJiB3ZGV2LT5pZnR5cGUgPT0g
Tkw4MDIxMV9JRlRZUEVfTU9OSVRPUikgeworICAgICAgICBtb25fZGV2ID0gd2RldjsKIAkJd2Rl
diA9IE5VTEw7Ci0KKyAgICB9CiAJaWYgKHdkZXYpIHsKIAkJQVNTRVJUX1dERVZfTE9DSyh3ZGV2
KTsKIApAQCAtMTMxLDUgKzEzMyw4IEBAIGludCBjZmc4MDIxMV9zZXRfZnJlcShzdHJ1Y3QgY2Zn
ODAyMTFfcmVnaXN0ZXJlZF9kZXZpY2UgKnJkZXYsCiAJaWYgKHdkZXYpCiAJCXdkZXYtPmNoYW5u
ZWwgPSBjaGFuOwogCisgICAgaWYgKG1vbl9kZXYpCisgICAgICAgIG1vbl9kZXYtPmNoYW5uZWwg
PSBjaGFuOworCiAJcmV0dXJuIDA7CiB9Cg==
--0015174735daaf712904a66669b0--
