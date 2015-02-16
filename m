Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:62292 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbbBPS0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 13:26:47 -0500
Received: by mail-ob0-f172.google.com with SMTP id nt9so44955747obb.3
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2015 10:26:46 -0800 (PST)
Message-ID: <54E23664.70509@lwfinger.net> (sfid-20150216_192651_602827_8F9D5AA6)
Date: Mon, 16 Feb 2015 12:26:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alan Fisher <acf@unixcube.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: PROBLEM: rtlwifi drops most IPv6 packets
References: <54E19DD6.9050704@unixcube.org>
In-Reply-To: <54E19DD6.9050704@unixcube.org>
Content-Type: multipart/mixed;
 boundary="------------090100050405060808070108"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090100050405060808070108
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/16/2015 01:35 AM, Alan Fisher wrote:

Alan,

I looked at the routine, and it is returning true for all IPv6 packets.

Does the attached patch for 3.18 or 3.19 help?

Larry


--------------090100050405060808070108
Content-Type: text/plain; charset=UTF-8;
 name="modify_is_special_data"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="modify_is_special_data"

SW5kZXg6IHdpcmVsZXNzLWRyaXZlcnMtbmV4dC9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3
aWZpL2Jhc2UuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSB3aXJlbGVzcy1kcml2ZXJzLW5leHQub3Jp
Zy9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL2Jhc2UuYworKysgd2lyZWxlc3MtZHJp
dmVycy1uZXh0L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvYmFzZS5jCkBAIC0xMzQ3
LDcgKzEzNDcsNyBAQCB1OCBydGxfaXNfc3BlY2lhbF9kYXRhKHN0cnVjdCBpZWVlODAyMTFf
CiAJb2Zmc2V0ID0gbWFjX2hkcl9sZW4gKyBTTkFQX1NJWkUgKyBlbmNyeXB0X2hlYWRlcl9s
ZW47CiAJZXRoZXJfdHlwZSA9IGJlMTZfdG9fY3B1cCgoX19iZTE2ICopKHNrYi0+ZGF0YSAr
IG9mZnNldCkpOwogCi0JaWYgKEVUSF9QX0lQID09IGV0aGVyX3R5cGUpIHsKKwlpZiAoRVRI
X1BfSVAgPT0gZXRoZXJfdHlwZSB8fCBFVEhfUF9JUFY2ID09IGV0aGVyX3R5cGUpIHsKIAkJ
aXAgPSAoc3RydWN0IGlwaGRyICopKCh1OCAqKXNrYi0+ZGF0YSArIG9mZnNldCArCiAJCSAg
ICAgUFJPVE9DX1RZUEVfU0laRSk7CiAJCWlmIChJUFBST1RPX1VEUCA9PSBpcC0+cHJvdG9j
b2wpIHsKQEAgLTEzODYsOCArMTM4Niw2IEBAIHU4IHJ0bF9pc19zcGVjaWFsX2RhdGEoc3Ry
dWN0IGllZWU4MDIxMV8KIAkJfQogCiAJCXJldHVybiB0cnVlOwotCX0gZWxzZSBpZiAoMHg4
NkREID09IGV0aGVyX3R5cGUpIHsKLQkJcmV0dXJuIHRydWU7CiAJfQogCiBlbmQ6Cg==
--------------090100050405060808070108--
