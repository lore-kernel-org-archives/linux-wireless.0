Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52782 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2ECURT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 16:17:19 -0400
Received: by wibhj6 with SMTP id hj6so723216wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 13:17:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120503200948.GC11326@ritirata.org>
References: <CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
	<20120501183415.GG4316@ritirata.org>
	<20120501205616.GA2563@ritirata.org>
	<4595B4D22AB93C4FABBA84AAD5AA37FD14438A@ORSMSX103.amr.corp.intel.com>
	<CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
	<20120502153914.GA9285@tuxdriver.com>
	<20120502162100.GA2528@ritirata.org>
	<20120503065351.GB2307@ritirata.org>
	<CANUX_P03yeuU7gpXbdPVeUBnco4Cz8v78e00x+SgYbhD5K8B5w@mail.gmail.com>
	<CANUX_P0zRjSy9LOVzkWtboqAsvkD4O6EcEXLo11W1Sbb307OJQ@mail.gmail.com>
	<20120503200948.GC11326@ritirata.org>
Date: Thu, 3 May 2012 23:17:14 +0300
Message-ID: <CANUX_P0DL+_V8RO-CNXQx=oHF0T-opO=uw-ukYOjjVgo_OyfUw@mail.gmail.com> (sfid-20120503_221723_823652_757ED291)
Subject: Re: iwlwifi warn_slowpath with 3.*
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d044287a68fbea704bf277d7b
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d044287a68fbea704bf277d7b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

ooops


here it is



Emmanuel Grumbach
egrumbach@gmail.com


On Thu, May 3, 2012 at 11:09 PM, Antonio Quartulli <ordex@autistici.org> wr=
ote:
> On Thu, May 03, 2012 at 10:55:12PM +0300, Emmanuel Grumbach wrote:
>> Hi
>>
>> can you please apply the patch attached against wireless-testing ?
>
> which patch? If you refer to the patch attached to the bugreport, it does=
n't
> apply on wireless-testing.
>
>
> Cheers,
>
>>
>> You will have quite a lot of prints, so you will probably need to send
>> /var/log/syslog or messages
>>
>>
>> Thanks
>>
>> Emmanuel Grumbach
>> egrumbach@gmail.com
>>
>>
>> On Thu, May 3, 2012 at 10:04 PM, Emmanuel Grumbach <egrumbach@gmail.com>=
 wrote:
>> > Please enable CONFIG_FRAME_POINTERS
>> > Emmanuel Grumbach
>> > egrumbach@gmail.com
>> >
>> >
>> > On Thu, May 3, 2012 at 9:53 AM, Antonio Quartulli <ordex@autistici.org=
> wrote:
>> >> On Wed, May 02, 2012 at 06:21:02PM +0200, Antonio Quartulli wrote:
>> >>> On Wed, May 02, 2012 at 11:39:14AM -0400, John W. Linville wrote:
>> >>> > On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbach wrote:
>> >>> > > On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
>> >>> > > <meenakshi.venkataraman@intel.com> wrote:
>> >>> > > > Hi Antonio,
>> >>> > > >
>> >>> > > >>> it seems so. It happens at least once at boot time.
>> >>> > > >>> I will try wireless-testing and see what happens. Then I wil=
l apply your patch.
>> >>> > > >>
>> >>> > > >>The problem is there either with wireless-testing and with
>> >>> > > >>wireless-testing+your_patch.
>> >>> > > >>
>> >>> > > >>If it can somehow help, I also got several stack trace regardi=
ng intel_iova
>> >>> > > >>functions. But then the I got kernel panic and I was not able =
to copy the
>> >>> > > >>messages.
>> >>> > > >
>> >>> > > > [MV] Depending on how you set it up, perhaps the stack trace w=
as saved in one of the syslog files in /var/log/...
>> >>> > > >
>> >>> > > > Thanks!
>> >>> > > > Meenakshi
>> >>> > > >
>> >>> > >
>> >>> > > Can you please re-run with debug=3D1 and send the whole log ?
>> >>> > > This will give a better indication on when the issue occurs.
>> >>> >
>> >>> > Does this help?
>> >>> >
>> >>> > =A0 =A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D815998#c18
>> >>>
>> >>> I applied patch in comment 17 on linux-3.3.4. IT didn't help but thi=
s time I got
>> >>> the WARNING even with debug=3D1. Log is attached.
>> >>>
>> >>
>> >>
>> >> Is there any particular kernel debugging option I could enable to mak=
e the log
>> >> more verbose?
>> >>
>> >>
>> >> Cheers,
>> >>
>> >>
>> >>
>> >> --
>> >> Antonio Quartulli
>> >>
>> >> ..each of us alone is worth nothing..
>> >> Ernesto "Che" Guevara
>
> --
> Antonio Quartulli
>
> ..each of us alone is worth nothing..
> Ernesto "Che" Guevara

--f46d044287a68fbea704bf277d7b
Content-Type: application/octet-stream; name="print.patch"
Content-Disposition: attachment; filename="print.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1s98q9x1

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXRyYW5zLXBjaWUt
cnguYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXRyYW5zLXBjaWUtcnguYwpp
bmRleCA1MDIwMmQ3Li41NDA4MzBiIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9p
d2x3aWZpL2l3bC10cmFucy1wY2llLXJ4LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXds
d2lmaS9pd2wtdHJhbnMtcGNpZS1yeC5jCkBAIC0zMTcsNiArMzE3LDcgQEAgc3RhdGljIHZvaWQg
aXdsYWduX3J4X2FsbG9jYXRlKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLCBnZnBfdCBwcmlvcml0
eSkKIAkJcnhiLT5wYWdlX2RtYSA9IGRtYV9tYXBfcGFnZSh0cmFucy0+ZGV2LCBwYWdlLCAwLAog
CQkJCVBBR0VfU0laRSA8PCB0cmFuc19wY2llLT5yeF9wYWdlX29yZGVyLAogCQkJCURNQV9GUk9N
X0RFVklDRSk7CisJCUlXTF9FUlIodHJhbnMsICJNYXBwZWQgJXAgdG8gJXBcbiIsIHBhZ2UsIHJ4
Yi0+cGFnZV9kbWEpOwogCQkvKiBkbWEgYWRkcmVzcyBtdXN0IGJlIG5vIG1vcmUgdGhhbiAzNiBi
aXRzICovCiAJCUJVR19PTihyeGItPnBhZ2VfZG1hICYgfkRNQV9CSVRfTUFTSygzNikpOwogCQkv
KiBhbmQgYWxzbyAyNTYgYnl0ZSBhbGlnbmVkISAqLwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvaXdsd2lmaS9pd2wtdHJhbnMtcGNpZS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aXdsd2lmaS9pd2wtdHJhbnMtcGNpZS5jCmluZGV4IGUxNzYxYzUuLmIyYzMyZGIgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXRyYW5zLXBjaWUuYworKysgYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10cmFucy1wY2llLmMKQEAgLTEzMyw2ICsx
MzMsNyBAQCBzdGF0aWMgdm9pZCBpd2xfdHJhbnNfcnhxX2ZyZWVfcnhfYnVmcyhzdHJ1Y3QgaXds
X3RyYW5zICp0cmFucykKIAkJLyogSW4gdGhlIHJlc2V0IGZ1bmN0aW9uLCB0aGVzZSBidWZmZXJz
IG1heSBoYXZlIGJlZW4gYWxsb2NhdGVkCiAJCSAqIHRvIGFuIFNLQiwgc28gd2UgbmVlZCB0byB1
bm1hcCBhbmQgZnJlZSBwb3RlbnRpYWwgc3RvcmFnZSAqLwogCQlpZiAocnhxLT5wb29sW2ldLnBh
Z2UgIT0gTlVMTCkgeworCQkJSVdMX0VSUih0cmFucywgIkZyZWUgJWkgJXAgJXBcbiIsIGksIHJ4
cS0+cG9vbFtpXS5wYWdlLCByeHEtPnBvb2xbaV0ucGFnZV9kbWEpOwogCQkJZG1hX3VubWFwX3Bh
Z2UodHJhbnMtPmRldiwgcnhxLT5wb29sW2ldLnBhZ2VfZG1hLAogCQkJCVBBR0VfU0laRSA8PCB0
cmFuc19wY2llLT5yeF9wYWdlX29yZGVyLAogCQkJCURNQV9GUk9NX0RFVklDRSk7CkBAIC0xNDAs
NiArMTQxLDggQEAgc3RhdGljIHZvaWQgaXdsX3RyYW5zX3J4cV9mcmVlX3J4X2J1ZnMoc3RydWN0
IGl3bF90cmFucyAqdHJhbnMpCiAJCQkJICAgICB0cmFuc19wY2llLT5yeF9wYWdlX29yZGVyKTsK
IAkJCXJ4cS0+cG9vbFtpXS5wYWdlID0gTlVMTDsKIAkJfQorCQllbHNlCisJCQlJV0xfRVJSKHRy
YW5zLCAiJWQgaXMgTlVMTCAlcCIsIGksIHJ4cS0+cG9vbFtpXS5wYWdlX2RtYSk7CiAJCWxpc3Rf
YWRkX3RhaWwoJnJ4cS0+cG9vbFtpXS5saXN0LCAmcnhxLT5yeF91c2VkKTsKIAl9CiB9Cg==
--f46d044287a68fbea704bf277d7b--
