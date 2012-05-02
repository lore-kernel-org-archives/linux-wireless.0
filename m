Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52809 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2EBGN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 02:13:29 -0400
Received: by were53 with SMTP id e53so142625wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 23:13:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P0mfez7RDfAnUQg_rn1Ow1drXiZ4b6G2y6Ph5+Yqot=kA@mail.gmail.com>
References: <CAOvK7nAOHqKC8rpFDqGnW7NLCX-G2+syRGih_rv7N5O5rfOUdA@mail.gmail.com>
	<CANUX_P1t8XJOka-QGzZSYFHb6MLc7rm4madn059Yg4b6hJB49A@mail.gmail.com>
	<CAOvK7nDO4fS6R5go+ZXYBqyQc8hhbJGun9Weh=-EyX5k11+tXw@mail.gmail.com>
	<CANUX_P2rzvDCBVLmU2rfaZmUOCMuMDe5=TXE_jwxq4ULrvc=QQ@mail.gmail.com>
	<CAOvK7nCwRbDNZSnn0EvFMpcQMvX1DmU-tBuFT4kRW1TigwyJDQ@mail.gmail.com>
	<CANUX_P0JsyA53T_vs5Ea0pE5Ye4G9xRC4xKcdwgAmoC8E63sHg@mail.gmail.com>
	<CAOvK7nCf6k_ugJ=UBF8y0VBr_kVmESpetfnpn=NW73r_K=kKyw@mail.gmail.com>
	<CAOvK7nCGwqqqrWNQhPqZoBqs6eT11gQNYbrZhb0bNSPTS-YxEw@mail.gmail.com>
	<CANUX_P2DDQ-U9Yz2YksEEpOgjyyYO1GnFHR8ogEHNwojKvn3yg@mail.gmail.com>
	<CAOvK7nB0L9GcnV-cNONndZMrAVLfFf3VaY4T-gPb+FgrNByeSA@mail.gmail.com>
	<CANUX_P38L7OqBNeK+jO0EPMHf1M3QKxmsTA6o-t+6ujoq1VJ5w@mail.gmail.com>
	<CAOvK7nB1gnnWcv6HFrn1MhMe-FheRtdTpi+BhCcCYNx6RowaTQ@mail.gmail.com>
	<CANUX_P3SFmNKqUTt53EHkAjupAoB8ZxQZZP1osm7=JwfHnwbqg@mail.gmail.com>
	<CANUX_P1ivcpLxm4z5k8SU+hGXG0A1hbSMnps7_i025kaAThyCg@mail.gmail.com>
	<CAOvK7nBGBDWhQnq8MT51dE=LXUxoQH1FLJ2TNUr42He1KbBurg@mail.gmail.com>
	<CANUX_P25bU36A0n4YSO1mBUTn9pxYYua28=o9Soo12mVyZNVcQ@mail.gmail.com>
	<CANUX_P3+4hTGJSoo669LixMmNjxv1pqAwmLgVi16iF+LX7-ebQ@mail.gmail.com>
	<CAOvK7nA7=B_=kaQasYpwAegNG21GdxCuTZ5z+T7PMYPNaTxsXA@mail.gmail.com>
	<CANUX_P3JrvyV7wXCkeXaS4k3GgcRxkSPW_5TGpqXFhrHKp5OYQ@mail.gmail.com>
	<CAOvK7nAOGwdDbwCPPFg+2w4DiUv75ppY0wSK6rjUqaZGHHmk4g@mail.gmail.com>
	<CANUX_P0mfez7RDfAnUQg_rn1Ow1drXiZ4b6G2y6Ph5+Yqot=kA@mail.gmail.com>
Date: Wed, 2 May 2012 09:13:28 +0300
Message-ID: <CANUX_P2YonE17M5T3ZUGARt6UqcHy4LmPnDvwQJaWJLbv6VibQ@mail.gmail.com> (sfid-20120502_081333_531049_AD455CB3)
Subject: Re: iwlwifi bug
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: dchyan@princeton.edu
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d0444047af599b604bf079560
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d0444047af599b604bf079560
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, May 1, 2012 at 11:09 PM, Emmanuel Grumbach <egrumbach@gmail.com> wr=
ote:
> On Tue, May 1, 2012 at 20:52, Daniel Chyan <dchyan@princeton.edu> wrote:
>> Well I believe I can reproduce it by downgrading to an older driver,
>> but I am unable to reproduce it now.
>>
>
> I had sent a fix for that, but the driver you were running when you
> reported the issue already included the fix.


Patch attached. It should fix it.
Will be pushed through our maintainer soon.

>
>> On Mon, Apr 30, 2012 at 3:22 PM, Emmanuel Grumbach <egrumbach@gmail.com>=
 wrote:
>>> On Mon, Apr 30, 2012 at 21:41, Daniel Chyan <dchyan@princeton.edu> wrot=
e:
>>>> I am running iwlwifi with the additional flags. Nothing particularly
>>>> alarming has appeared in the logs, but I have attached it.
>>>>
>>>
>>> Yeah... I was hoping you could reliably reproduce the issue but
>>> apparently not :-)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

--f46d0444047af599b604bf079560
Content-Type: application/octet-stream;
	name="0001-iwlwifi-don-t-disable-AGG-queues-that-are-not-enable.patch"
Content-Disposition: attachment;
	filename="0001-iwlwifi-don-t-disable-AGG-queues-that-are-not-enable.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1pzndlz0

RnJvbSBhNmQ4MGJmNTNiNjVjM2VmZmRkNTUzZWRiN2U1ZmIzYThhODdhY2JiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hA
aW50ZWwuY29tPgpEYXRlOiBXZWQsIDIgTWF5IDIwMTIgMDg6NDU6NDkgKzAzMDAKU3ViamVjdDog
W1BBVENIIDEvMl0gaXdsd2lmaTogZG9uJ3QgZGlzYWJsZSBBR0cgcXVldWVzIHRoYXQgYXJlIG5v
dCBlbmFibGVkCgpJZiB0aGUgQkEgc2Vzc2lvbiBpcyB0b3JuIGRvd24gYmVmb3JlIHdlIGhhZCBh
IGNoYW5jZSB0byBzdGFydCBpdAp3ZSBzaG91bGRuJ3QgZGlzYWJsZSB0aGUgQUdHIHR4IHF1ZXVl
cyB0aGF0IHdlcmVuJ3QgZW5hYmxlZC4KVGhpcyBjYW4gaGFwcGVuIGluIHR3byBjYXNlczoKCjEp
IFdlIGdldCBhIGRlbEJBIGJlZm9yZSB3ZSBkcmFpbmVkIG91ciBUeCBxdWV1ZXMgaW4gYWdnIHN0
YXJ0IGZsb3cKMikgV2UgZGlkbid0IGdldCB0aGUgKHN1Y2Nlc3NmdWxsKSBhZGRCQSByZXNwb25z
ZSBvbiB0aW1lCgpSZXBvcnRlZC1ieTogRGFuaWVsIENoeWFuIDxkY2h5YW5AcHJpbmNldG9uLmVk
dT4KU2lnbmVkLW9mZi1ieTogRW1tYW51ZWwgR3J1bWJhY2ggPGVtbWFudWVsLmdydW1iYWNoQGlu
dGVsLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1hZ24tdHguYyB8
ICAgMTMgKysrKysrKysrKy0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkv
aXdsLWFnbi10eC5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXR4LmMK
aW5kZXggZjJlOWYyOS4uMDliYWY2ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aXdsd2lmaS9pd2wtYWduLXR4LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9p
d2wtYWduLXR4LmMKQEAgLTU5MCwxMSArNTkwLDE4IEBAIHR1cm5fb2ZmOgogCXNwaW5fdW5sb2Nr
X2JoKCZwcml2LT5zdGFfbG9jayk7CiAKIAlpZiAodGVzdF9iaXQodHhxX2lkLCBwcml2LT5hZ2df
cV9hbGxvYykpIHsKLQkJLyogSWYgdGhlIHRyYW5zcG9ydCBkaWRuJ3Qga25vdyB0aGF0IHdlIHdh
bnRlZCB0byBzdGFydAotCQkgKiBhZ3JlZ2dhdGlvbiwgZG9uJ3QgdGVsbCBpdCB0aGF0IHdlIHdh
bnQgdG8gc3RvcCB0aGVtCisJCS8qCisJCSAqIElmIHRoZSB0cmFuc3BvcnQgZGlkbid0IGtub3cg
dGhhdCB3ZSB3YW50ZWQgdG8gc3RhcnQKKwkJICogYWdyZWdnYXRpb24sIGRvbid0IHRlbGwgaXQg
dGhhdCB3ZSB3YW50IHRvIHN0b3AgdGhlbS4KKwkJICogVGhpcyBjYW4gaGFwcGVuIHdoZW4gd2Ug
ZG9uJ3QgZ2V0IHRoZSBhZGRCQSByZXNwb25zZSBvbgorCQkgKiB0aW1lLgogCQkgKi8KLQkJaWYg
KGFnZ19zdGF0ZSAhPSBJV0xfQUdHX1NUQVJUSU5HKQorCQlpZiAoYWdnX3N0YXRlID09IElXTF9B
R0dfT04pCiAJCQlpd2xfdHJhbnNfdHhfYWdnX2Rpc2FibGUocHJpdi0+dHJhbnMsIHR4cV9pZCk7
CisJCWVsc2UKKwkJCUlXTF9ERUJVR19UWF9RVUVVRVMocHJpdiwgIkRvbid0IGRpc2FibGUgdHgg
YWdnIHNpbmNlIgorCQkJCQkgICAgIiBBR0cgaGFzbid0IGJlZW4gc3RhcnRlZDoiCisJCQkJCSAg
ICAiIHN0YXRlICVkXG4iLCBhZ2dfc3RhdGUpOwogCQlpd2xhZ25fZGVhbGxvY19hZ2dfdHhxKHBy
aXYsIHR4cV9pZCk7CiAJfQogCi0tIAoxLjcuMQoK
--f46d0444047af599b604bf079560--
