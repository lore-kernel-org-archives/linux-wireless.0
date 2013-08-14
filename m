Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:57228 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397Ab3HNDpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 23:45:35 -0400
Received: by mail-oa0-f53.google.com with SMTP id k18so12291536oag.26
        for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2013 20:45:34 -0700 (PDT)
Message-ID: <520AFD5C.3010905@lwfinger.net> (sfid-20130814_060908_803308_6DCDEB7A)
Date: Tue, 13 Aug 2013 22:45:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Phillip Moss <phillipmoss12@yahoo.es>
CC: linux-wireless@vger.kernel.org
Subject: Re: Signal loss rtl8723ae wifi driver
References: <1376411031.31841.YahooMailBasic@web171406.mail.ir2.yahoo.com>
In-Reply-To: <1376411031.31841.YahooMailBasic@web171406.mail.ir2.yahoo.com>
Content-Type: multipart/mixed;
 boundary="------------060306060109010703060809"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060306060109010703060809
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/13/2013 11:23 AM, Phillip Moss wrote:
> Hi all,
> I have a rtl8723ae wifi card on my laptop. When connecting to any wifi Access Point
> the wifi signal fluctuates from full strength to very low.  In order to connect and
> stay connected I must be no farther than two meters from my router otherwise I get
> disconnected. I have tried the kernel driver on multiple distros as well as the
> vendor drivers for older kernel versions. All seem to have the same problem. The card
> works ok on Windows 7 with vendor drivers. I have also tried compiling
> backports-3.10-rc1-2 with no luck. During a signal loss period I get no logs but if I
> take the laptop too far from the AP dmesg reports:

Philip,

Could you try the attached patch?

Larry


--------------060306060109010703060809
Content-Type: text/plain; charset=UTF-8;
 name="rtl8723ae_increase_gain"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rtl8723ae_increase_gain"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODcyM2FlL3Ry
eC5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4NzIzYWUvdHJ4LmMKaW5k
ZXggYzcyNzU4ZC4uNzVjZjZmZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cnRsd2lmaS9ydGw4NzIzYWUvdHJ4LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRs
d2lmaS9ydGw4NzIzYWUvdHJ4LmMKQEAgLTEzMCw3ICsxMzAsNyBAQCBzdGF0aWMgdm9pZCBf
cnRsODcyM2FlX3F1ZXJ5X3J4cGh5c3RhdHVzKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAog
CQkvKiBDQ0sgZ2FpbiBpcyBzbWFsbGVyIHRoYW4gT0ZETS9NQ1MgZ2FpbiwKIAkJICogc28g
d2UgYWRkIGdhaW4gZGlmZi4gRnJvbSBleHBlcmllbmNlLCB0aGUgdmFsIGlzIDYKIAkJICov
Ci0JCXB3ZGJfYWxsICs9IDY7CisJCXB3ZGJfYWxsICs9IDEwOwogCQlpZiAocHdkYl9hbGwg
PiAxMDApCiAJCQlwd2RiX2FsbCA9IDEwMDsKIAkJLyogbW9kaWZ5IHRoZSBvZmZzZXQgdG8g
bWFrZSB0aGUgc2FtZQo=
--------------060306060109010703060809--
