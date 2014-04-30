Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:50127 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933648AbaD3OjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 10:39:20 -0400
Received: by mail-ob0-f172.google.com with SMTP id wo20so2079603obc.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2014 07:39:19 -0700 (PDT)
Message-ID: <53610B15.4000607@lwfinger.net> (sfid-20140430_163923_807852_98092836)
Date: Wed, 30 Apr 2014 09:39:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sven Eckelmann <sven@narfation.org>
CC: Tim Gardner <rtg.canonical@gmail.com>,
	Nicolas Vaquero <nicovaq92@hotmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel source
References: <535E7741.1030607@lwfinger.net> <3262959.TlL8alHHte@bentobox>
In-Reply-To: <3262959.TlL8alHHte@bentobox>
Content-Type: multipart/mixed;
 boundary="------------050902080908090507050407"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050902080908090507050407
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sven and Tim,

Attached is a one-line fix for the problem that shows up between 3.8.0-36 and 
3.8.0-37. It is just a bare patch file, but feel free to add any explanatory 
text to make it a proper commit.

I have no real understanding as to why this line of code does not cause any 
problems with later kernel versions, but it does here. In addition, I have not 
had any reports of problems with other users. That makes me suspect some kind of 
bad interaction with the user-space network control components in 12.04.

Would it be helpful for Nicolas to prepare a bug report at Ubuntu?

Larry



--------------050902080908090507050407
Content-Type: text/plain; charset=UTF-8;
 name="fix_ubuntu_crash"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fix_ubuntu_crash"

SW5kZXg6IGxpbnV4LTMuOC4zNy9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL2NvcmUu
Ywo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0zLjguMzcub3JpZy9kcml2ZXJzL25ldC93aXJl
bGVzcy9ydGx3aWZpL2NvcmUuYworKysgbGludXgtMy44LjM3L2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3J0bHdpZmkvY29yZS5jCkBAIC0xODcsNyArMTg3LDYgQEAgc3RhdGljIGludCBydGxf
b3BfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaQogCQkJCQlydGxwcml2LT5jZmctPm1hcHMKIAkJ
CQkJW1JUTF9JQlNTX0lOVF9NQVNLU10pOwogCQl9Ci0JCW1hYy0+bGlua19zdGF0ZSA9IE1B
QzgwMjExX0xJTktFRDsKIAkJYnJlYWs7CiAJY2FzZSBOTDgwMjExX0lGVFlQRV9BREhPQzoK
IAkJUlRfVFJBQ0UocnRscHJpdiwgQ09NUF9NQUM4MDIxMSwgREJHX0xPVUQsCgo=
--------------050902080908090507050407--
