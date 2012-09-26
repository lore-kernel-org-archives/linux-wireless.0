Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50373 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2IZPOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 11:14:42 -0400
Received: by vbbff1 with SMTP id ff1so738590vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 08:14:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50631B06.4030104@gmail.com>
References: <5062E0CB.6040308@gmail.com>
	<5062EBCE.70700@lenbrook.com>
	<CAD2nsn3Tkkk92WRhBhBtj8oU5edWZf4tgS2ex8doSAnGDGpcnA@mail.gmail.com>
	<5062F6A6.8000207@gmail.com>
	<CAD2nsn3u09ywKek2DT+R__eezq68tTzC43OuQCZCGf3_QKa8cg@mail.gmail.com>
	<50631B06.4030104@gmail.com>
Date: Wed, 26 Sep 2012 20:44:41 +0530
Message-ID: <CAD2nsn2MpHi7SB08bwsLHGHed62NGkdwWao75YFW+yMb4pUR6A@mail.gmail.com> (sfid-20120926_171446_944196_F4669F32)
Subject: Re: ath6kl ar6004/ar9374 (hw 1.3) WPA/WPA2 supported ?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ben Gray <ben.r.gray@gmail.com>
Cc: Jonathan Bagg <jbagg@lenbrook.com>, linux-wireless@vger.kernel.org,
	jouni@qca.qualcomm.com
Content-Type: multipart/mixed; boundary=20cf307c9cb23442b004ca9c4804
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--20cf307c9cb23442b004ca9c4804
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Sep 26, 2012 at 8:41 PM, Ben Gray <ben.r.gray@gmail.com> wrote:
>
>> On Wed, Sep 26, 2012 at 6:05 PM, Ben Gray <ben.r.gray@gmail.com> wrote:
>>>
>>> Wow that was quick, thanks very much.  Any idea when it will make it
>>> upstream ?
>>
>>
>> can you please try the attached patch. I will just put tested-by if it
>> works for you too.
>> It works for me.
>
> Yes, that works for me :), I've tried both WPA and WPA2 and both work so
> far.
>
> Many thanks Mohammed, it's much appreciated.


thanks i will add tested-by with the attached to be sent patch
>
>>
>>>
>>> I've attached the wpa_supplicant (v0.7.3) log in case anyone is still
>>> interested.
>>>
>>> Thanks everyone for your replies,
>>>
>>> Ben.
>>>
>>>
>>>
>>> On 26/09/2012 13:19, Mohammed Shafi wrote:
>>>>
>>>>
>>>> On Wed, Sep 26, 2012 at 5:19 PM, Jonathan Bagg <jbagg@lenbrook.com>
>>>> wrote:
>>>>>
>>>>>
>>>>> I've had the same experience, I can connect with iw, but not with
>>>>> wpa_supplicant with wpa.  I also couldn't get higher than 65Mbps, MCS7
>>>>> (other devices on the same router will go faster).  I'm probably the
>>>>> other
>>>>> post you mentioned.
>>>>
>>>>
>>>>
>>>> We have a fix, I shall validate it and send it upstream.
>>>>>
>>>>>
>>>>>
>>>>> Jon
>>>>>
>>>>>
>>>>> On 12-09-26 07:02 AM, Ben Gray wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>>       I have a bunch of UB134 USB dongles which have a ath6kl chip
>>>>>> with
>>>>>> H/W
>>>>>> version 0x31c8088a, I'm trying to get them to work with the ath6kl
>>>>>> driver
>>>>>> from the compat-wireless-3.6-rc5-1 package. I've applied this
>>>>>> (https://patchwork.kernel.org/patch/1203191/) patch to the source and
>>>>>> pulled
>>>>>> the hw1.3 firmware from the linux-firmware git.
>>>>>>
>>>>>>       The driver works as far as it can scan AP's and connect to
>>>>>> unencrypted
>>>>>> networks, however WPA/WPA2 doesn't work when I run wpa_supplicant. I
>>>>>> realise
>>>>>> "WPA doesn't work" is a bit vague, and I can post the wpa_supplicant
>>>>>> and
>>>>>> driver logs if that helps, but I've seen another post which says they
>>>>>> couldn't get WPA to work either, so I'd like to know if this is a
>>>>>> known
>>>>>> issue with the driver and/or firmware? Has anyone had any luck getting
>>>>>> WPA/WPA2 working with ath6kl hw1.3 ?
>>>>>>
>>>>>>       If this is a known issue does anyone know when it might be fixed
>>>>>> ?
>>>>>>
>>>>>>
>>>>>> Thanks in advance,
>>>>>> Ben.
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>> linux-wireless"
>>>>>> in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-wireless"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>
>>>>
>>>>
>>>
>>
>>
>>
>



-- 
thanks,
shafi

--20cf307c9cb23442b004ca9c4804
Content-Type: application/octet-stream;
	name="0001-ath6kl-Fix-mapping-uplink-endpoint-for-AR6004.patch"
Content-Disposition: attachment;
	filename="0001-ath6kl-Fix-mapping-uplink-endpoint-for-AR6004.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7kkrnzu0

RnJvbSA0YzczYzQzMWUxNmExYjViYWExNWYwMGIyMTllZTVhNjkwYjUxYmYwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNb2hhbW1lZCBTaGFmaSBTaGFqYWtoYW4gPG1vaGFtbWVkQHFj
YS5xdWFsY29tbS5jb20+CkRhdGU6IFdlZCwgMjYgU2VwIDIwMTIgMTk6NDE6MzUgKzA1MzAKU3Vi
amVjdDogW1BBVENIXSBhdGg2a2w6IEZpeCBtYXBwaW5nIHVwbGluayBlbmRwb2ludCBmb3IgQVI2
MDA0CgpBUjYwMDQgKFVCMTM0KSBmaXJtd2FyZSBzdXBwb3J0cyBvbmx5IExQIEVuZHBvaW50LCBT
byBtYXAKYWxsIEFjY2VzcyBDYXRlZ29yaWVzIHRvIExvdyBlbmRwb2ludHMuIFRoaXMgZml4ZXMg
YSBXUEEyCmNvbm5lY3Rpb24gaXNzdWUgYXMgdGhlIHVwbGluayh0eCkgZW5kcG9pbnQgaXMgYXBw
cm9wcmlhdGVseQptYXBwZWQgaW4gc3luYyB3aXRoIHRoZSBmaXJtd2FyZS4KClJlcG9ydGVkLWJ5
OiBCZW4gR3JheSA8YmVuLnIuZ3JheUBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IE1vaGFtbWVk
IFNoYWZpIFNoYWpha2hhbiA8bW9oYW1tZWRAcWNhLnF1YWxjb21tLmNvbT4KLS0tCiBkcml2ZXJz
L25ldC93aXJlbGVzcy9hdGgvYXRoNmtsL2luaXQuYyB8ICAgIDUgKysrLS0KIGRyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGg2a2wvdXNiLmMgIHwgICAxMiArKysrKysrKysrLS0KIDIgZmlsZXMg
Y2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNmtsL2luaXQuYyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGg2a2wvaW5pdC5jCmluZGV4IGU1ZTliMmMuLmRlOWQ5MWMgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg2a2wvaW5pdC5jCisrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGg2a2wvaW5pdC5jCkBAIC0zNjAsNyArMzYwLDcgQEAgc3RhdGljIGlu
dCBhdGg2a2xfaW5pdF9zZXJ2aWNlX2VwKHN0cnVjdCBhdGg2a2wgKmFyKQogCWlmIChhdGg2a2xf
Y29ubmVjdHNlcnZpY2UoYXIsICZjb25uZWN0LCAiV01JIERBVEEgQksiKSkKIAkJcmV0dXJuIC1F
SU87CiAKLQkvKiBjb25uZWN0IHRvIFZpZGVvIHNlcnZpY2UsIG1hcCB0aGlzIHRvIHRvIEhJIFBS
SSAqLworCS8qIGNvbm5lY3QgdG8gVmlkZW8gc2VydmljZSwgbWFwIHRoaXMgdG8gdG8gTE9XX1BS
SSAqLwogCWNvbm5lY3Quc3ZjX2lkID0gV01JX0RBVEFfVklfU1ZDOwogCWlmIChhdGg2a2xfY29u
bmVjdHNlcnZpY2UoYXIsICZjb25uZWN0LCAiV01JIERBVEEgVkkiKSkKIAkJcmV0dXJuIC1FSU87
CkBAIC0zNzAsNyArMzcwLDggQEAgc3RhdGljIGludCBhdGg2a2xfaW5pdF9zZXJ2aWNlX2VwKHN0
cnVjdCBhdGg2a2wgKmFyKQogCSAqIHByaW9yaXR5IHN0cmVhbSBkdWUgdG8gaGlzdG9yaWNhbCBy
ZWFzb25zLiBXTUkgb3JpZ2luYWxseQogCSAqIGRlZmluZWQgMyBwcmlvcml0aWVzIG92ZXIgMyBt
YWlsYm94ZXMgV2UgY2FuIGNoYW5nZSB0aGlzIHdoZW4KIAkgKiBXTUkgaXMgcmV3b3JrZWQgc28g
dGhhdCBwcmlvcml0aWVzIGFyZSBub3QgZGVwZW5kZW50IG9uCi0JICogbWFpbGJveGVzLgorCSAq
IG1haWxib3hlcy4gVGhpcyBpcyBhbHNvIG1hcHBlZCB0byBMT1dfUFJJIGVuZHBvaW50IGluIHN5
bmMgd2l0aAorCSAqIHRoZSBmaXJtd2FyZS4KIAkgKi8KIAljb25uZWN0LnN2Y19pZCA9IFdNSV9E
QVRBX1ZPX1NWQzsKIAlpZiAoYXRoNmtsX2Nvbm5lY3RzZXJ2aWNlKGFyLCAmY29ubmVjdCwgIldN
SSBEQVRBIFZPIikpCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNmts
L3VzYi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDZrbC91c2IuYwppbmRleCBhNmQx
Mzc3Li41Yzg4ODZjIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNmts
L3VzYi5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg2a2wvdXNiLmMKQEAgLTgw
Myw3ICs4MDMsMTEgQEAgc3RhdGljIGludCBhdGg2a2xfdXNiX21hcF9zZXJ2aWNlX3BpcGUoc3Ry
dWN0IGF0aDZrbCAqYXIsIHUxNiBzdmNfaWQsCiAJCSpkbF9waXBlID0gQVRINktMX1VTQl9QSVBF
X1JYX0RBVEE7CiAJCWJyZWFrOwogCWNhc2UgV01JX0RBVEFfVklfU1ZDOgotCQkqdWxfcGlwZSA9
IEFUSDZLTF9VU0JfUElQRV9UWF9EQVRBX01QOworCisJCWlmIChhci0+dmVyc2lvbi50YXJnZXRf
dmVyID09IEFSNjAwNF9IV18xXzNfVkVSU0lPTikKKwkJCSp1bF9waXBlID0gQVRINktMX1VTQl9Q
SVBFX1RYX0RBVEFfTFA7CisJCWVsc2UKKwkJCSp1bF9waXBlID0gQVRINktMX1VTQl9QSVBFX1RY
X0RBVEFfTVA7CiAJCS8qCiAJCSogRGlzYWJsZSByeGRhdGEyIGRpcmVjdGx5LCBpdCB3aWxsIGJl
IGVuYWJsZWQKIAkJKiBpZiBGVyBlbmFibGUgcnhkYXRhMgpAQCAtODExLDcgKzgxNSwxMSBAQCBz
dGF0aWMgaW50IGF0aDZrbF91c2JfbWFwX3NlcnZpY2VfcGlwZShzdHJ1Y3QgYXRoNmtsICphciwg
dTE2IHN2Y19pZCwKIAkJKmRsX3BpcGUgPSBBVEg2S0xfVVNCX1BJUEVfUlhfREFUQTsKIAkJYnJl
YWs7CiAJY2FzZSBXTUlfREFUQV9WT19TVkM6Ci0JCSp1bF9waXBlID0gQVRINktMX1VTQl9QSVBF
X1RYX0RBVEFfSFA7CisKKwkJaWYgKGFyLT52ZXJzaW9uLnRhcmdldF92ZXIgPT0gQVI2MDA0X0hX
XzFfM19WRVJTSU9OKQorCQkJKnVsX3BpcGUgPSBBVEg2S0xfVVNCX1BJUEVfVFhfREFUQV9MUDsK
KwkJZWxzZQorCQkJKnVsX3BpcGUgPSBBVEg2S0xfVVNCX1BJUEVfVFhfREFUQV9NUDsKIAkJLyoK
IAkJKiBEaXNhYmxlIHJ4ZGF0YTIgZGlyZWN0bHksIGl0IHdpbGwgYmUgZW5hYmxlZAogCQkqIGlm
IEZXIGVuYWJsZSByeGRhdGEyCi0tIAoxLjcuMC40Cgo=
--20cf307c9cb23442b004ca9c4804--
