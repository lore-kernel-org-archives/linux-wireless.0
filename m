Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42494 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab2DYHcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 03:32:04 -0400
Received: by wibhq7 with SMTP id hq7so1488765wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 00:32:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P2yiz025rkcDsisNd0uFfEaVV=Gycf0fzWA29ct7R9aDg@mail.gmail.com>
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
	<8FBCAE90-FAE9-430D-888E-F055091E6683@gmail.com>
	<CANUX_P1OxH7rmYWxizEaf2DnPSTK0npNtZ2Q9Rm5dksnmFKD8g@mail.gmail.com>
	<9D52D4AD-58DC-4896-97FC-7248E1FD2614@gmail.com>
	<CANUX_P1ZX_e+0qs4sa7vdAqHvOQjO6+9PiFhDbW8ybE4ax80gQ@mail.gmail.com>
	<8EE08C44-8618-45EC-B890-B5B12B661FB6@gmail.com>
	<CANUX_P0O0-6sOaN59V_RxLj_DbiTdNdwq0zze6B6vMe1hfQuqA@mail.gmail.com>
	<37926591-261D-4C3E-A1D9-4A8AB3364F5D@gmail.com>
	<4F901224.1040508@sipsolutions.net>
	<EA757D90-2CCE-48A1-AF35-7F65EB45F7EE@gmail.com>
	<4F901F16.6080007@sipsolutions.net>
	<CAC79F14-24F2-4F90-8A47-B9B2744F5AE3@gmail.com>
	<CANUX_P2t86v0L=DDaaBdW-6Yb5ffSscv2aSy+jQ5dFc0TqWB_Q@mail.gmail.com>
	<CBC6370A-C51D-4CF6-99CE-AE8C35C467FB@gmail.com>
	<CANUX_P0RUv_d+A+uY5AZcb4Yo81+ihw_tPr4u2btAz66Pt_=0Q@mail.gmail.com>
	<04B86DB4-284B-4FA0-916F-75BF75863A5E@gmail.com>
	<CANUX_P2HP1PkPWR6=qW12bbRDtJpDY+5oYMbNajAXmJHjyjjuA@mail.gmail.com>
	<4F96939B.5030204@erley.org>
	<CA+icZUVWLyvSuGHUWsNZVmEZj84p4EppnZYTeaaU9-WF8g4AGw@mail.gmail.com>
	<D90BDD59-B256-445F-B9A3-F5481D57A5A7@gmail.com>
	<CA+icZUVmO7Ehim0FHVAEL37PMNSGhVNismAu1DoOwAbt1Rphzg@mail.gmail.com>
	<CANUX_P1HQVUFcxFLtWoL+wvEXbNTk0qEJVM+4yJKBbGuhWvZbw@mail.gmail.com>
	<CA+icZUUr9v-fc-86gAppJWF+c2PBE07eG28BNfQf+9ESvHqj=A@mail.gmail.com>
	<CANUX_P2yiz025rkcDsisNd0uFfEaVV=Gycf0fzWA29ct7R9aDg@mail.gmail.com>
Date: Wed, 25 Apr 2012 10:32:02 +0300
Message-ID: <CANUX_P3R-8b=2b-+UqTMDF+hvY20iMbD3aY3_mqgqK38sop25g@mail.gmail.com> (sfid-20120425_093219_405771_67F6C90A)
Subject: Re: wlan0 not present
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dominik Feser <dominik.feser@googlemail.com>
Cc: Pat Erley <pat-lkml@erley.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Content-Type: multipart/mixed; boundary=f46d0435c0620e944704be7bde69
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d0435c0620e944704be7bde69
Content-Type: text/plain; charset=ISO-8859-1

Out of curisosity Dominik,

can you please try the patch attached ?

thanks

Emmanuel Grumbach
egrumbach@gmail.com


On Wed, Apr 25, 2012 at 10:26, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Wed, Apr 25, 2012 at 09:23, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> On Tue, Apr 24, 2012 at 5:34 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> On Tue, Apr 24, 2012 at 15:45, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>> On Tue, Apr 24, 2012 at 2:29 PM, Dominik Feser
>>>> <dominik.feser@googlemail.com> wrote:
>>>>> What does that mean?
>>>>>
>>>>
>>>> Pickup the patch from [2], apply it against a recent compat-wireless
>>>> version, build and test.
>>>> Report here again.
>>>>
>>>
>>> Pretty sure it won't help. True, we were trying to request the wrong
>>> fw, but then we requested (and got) the good one, so that the only
>>> effect was that load time was longer that it could be. But here, we
>>> can't even get anything working. And the prints don't made it to
>>> kernel log properly
>>>
>>
>> Originally I answered Pat as he asked what's the status with the patch
>> concerning the firmware-issue.
>> So, my post was about applying this one (so I understood the open question).
>> I didn't care about the original concern of the reporter.
>> BTW, the mentioned patch is now in wireless.git (master-2012-04-24-2).
>
> fair enough :-)
>
>>
>> Currently, I have an issue myself on iwlwifi (6230) with Ubuntu
>> precise, but it looks like a bug in network-manager with 3.4-rc4+ (see
>> [1]).
>>
>> - Sedat -
>>
>> [1] https://bugzilla.redhat.com/show_bug.cgi?id=785772
>>
>
> Thanks for that pointer.

--f46d0435c0620e944704be7bde69
Content-Type: text/x-patch; charset=US-ASCII; name="ucode.patch"
Content-Disposition: attachment; filename="ucode.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1g6oi4a0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTYwMDAuYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTYwMDAuYwppbmRleCA2NDA2MGNkLi5mNWQw
YjVhIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC02MDAwLmMK
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtNjAwMC5jCkBAIC0zMzQsNyAr
MzM0LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBpd2xfYnRfcGFyYW1zIGl3bDYwMDBfYnRfcGFy
YW1zID0gewogI2RlZmluZSBJV0xfREVWSUNFXzYwMDUJCQkJCQlcCiAJLmZ3X25hbWVfcHJlID0g
SVdMNjAwNV9GV19QUkUsCQkJCVwKIAkudWNvZGVfYXBpX21heCA9IElXTDYwMDBHMl9VQ09ERV9B
UElfTUFYLAkJXAotCS51Y29kZV9hcGlfb2sgPSBJV0w2MDAwRzJfVUNPREVfQVBJX09LLAkJCVwK
KwkudWNvZGVfYXBpX29rID0gSVdMNjAwMEcyQl9VQ09ERV9BUElfT0ssCQlcCiAJLnVjb2RlX2Fw
aV9taW4gPSBJV0w2MDAwRzJfVUNPREVfQVBJX01JTiwJCVwKIAkubWF4X2luc3Rfc2l6ZSA9IElX
TDYwX1JUQ19JTlNUX1NJWkUsCQkJXAogCS5tYXhfZGF0YV9zaXplID0gSVdMNjBfUlRDX0RBVEFf
U0laRSwJCQlcCg==
--f46d0435c0620e944704be7bde69--
