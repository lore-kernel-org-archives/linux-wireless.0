Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45940 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2EFI0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 04:26:34 -0400
Received: by lbbgm6 with SMTP id gm6so2860946lbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 May 2012 01:26:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120506075433.GA1288@ritirata.org>
References: <CANUX_P0zRjSy9LOVzkWtboqAsvkD4O6EcEXLo11W1Sbb307OJQ@mail.gmail.com>
	<20120503200948.GC11326@ritirata.org>
	<CANUX_P0DL+_V8RO-CNXQx=oHF0T-opO=uw-ukYOjjVgo_OyfUw@mail.gmail.com>
	<20120504002136.GA4201@ritirata.org>
	<CANUX_P1Ji6H0zaA_kMHx2F1AD+czB=XtrDhjEvR8t1aCDpZhUQ@mail.gmail.com>
	<20120504063644.GA2912@ritirata.org>
	<CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com>
	<20120504142006.GA2040@ritirata.org>
	<CANUX_P28EcqDVXQkSrGk2fetf=Evf2Yd_Fg9Czwb1jEPpdgTWg@mail.gmail.com>
	<CANUX_P0ygFyDjOo1Thygw_dEiHKPPiH4=GDKN4ncX3vwy0ujrw@mail.gmail.com>
	<20120506075433.GA1288@ritirata.org>
Date: Sun, 6 May 2012 11:26:32 +0300
Message-ID: <CANUX_P09Bx=kZ+OoHLTdZgJy_rJOQvutg3yVrBLHzPzV=KMQsg@mail.gmail.com> (sfid-20120506_102643_695293_A67904FB)
Subject: Re: iwlwifi warn_slowpath with 3.*
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e0cb4efe28483bb6e604bf59e926
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--e0cb4efe28483bb6e604bf59e926
Content-Type: text/plain; charset=ISO-8859-1

All right,

Can you please test the patch I sent to you (which was good but not enough)
And add this one too ?

Thanks

Emmanuel Grumbach
egrumbach@gmail.com


On Sun, May 6, 2012 at 10:54 AM, Antonio Quartulli <ordex@autistici.org> wrote:
> On Sun, May 06, 2012 at 08:49:52 +0300, Emmanuel Grumbach wrote:
>> wait - I just noticed that this one introduced another issue...
>
> ok, I'll drop this patch
>
>>
>> Emmanuel Grumbach
>> egrumbach@gmail.com
>>
>>
>> On Sat, May 5, 2012 at 9:49 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> > Well,
>> >
>> > this is not the same warning as before.
>> > Can you try the patch attached ?
>> > I have submitted it internally.
>> >
>> > thanks
>> >
>> > Emmanuel Grumbach
>> > egrumbach@gmail.com
>> >
>> >
>> > On Fri, May 4, 2012 at 5:20 PM, Antonio Quartulli <ordex@autistici.org> wrote:
>> >> On Fri, May 04, 2012 at 09:58:30 +0300, Emmanuel Grumbach wrote:
>> >>> This can't be with my patch, is it ?
>> >>
>> >> here is the log. Some pieces are missing at the beginning, didn't check why.
>> >> However the WARNING comes up later, so it should be ok. Tell me if I can do
>> >> something else!
>> >>
>> >> Cheers,
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

--e0cb4efe28483bb6e604bf59e926
Content-Type: application/octet-stream; name="TX_idx.patch"
Content-Disposition: attachment; filename="TX_idx.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1vu6h961

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWRlYnVnZnMuYyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWRlYnVnZnMuYwppbmRleCA5YTVkMDgw
Li5jZGZiNDQ1IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1k
ZWJ1Z2ZzLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtZGVidWdmcy5j
CkBAIC0yMjEwLDcgKzIyMTAsNyBAQCBzdGF0aWMgaW50IGl3bF9jbWRfZWNob190ZXN0KHN0cnVj
dCBpd2xfcHJpdiAqcHJpdikKIAlzdHJ1Y3QgaXdsX2hvc3RfY21kIGNtZCA9IHsKIAkJLmlkID0g
UkVQTFlfRUNITywKIAkJLmxlbiA9IHsgMCB9LAotCQkuZmxhZ3MgPSBDTURfU1lOQywKKwkJLmZs
YWdzID0gQ01EX0FTWU5DLAogCX07CiAKIAlyZXQgPSBpd2xfZHZtX3NlbmRfY21kKHByaXYsICZj
bWQpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtdHJhbnMt
cGNpZS10eC5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtdHJhbnMtcGNpZS10
eC5jCmluZGV4IDE4ZmNjZjcuLmE1ZjExYzAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2l3bHdpZmkvaXdsLXRyYW5zLXBjaWUtdHguYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9pd2x3aWZpL2l3bC10cmFucy1wY2llLXR4LmMKQEAgLTE4Nyw2ICsxODcsOSBAQCBzdGF0aWMg
dm9pZCBpd2xhZ25fdW5tYXBfdGZkKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLCBzdHJ1Y3QgaXds
X2NtZF9tZXRhICptZXRhLAogCS8qIFNhbml0eSBjaGVjayBvbiBudW1iZXIgb2YgY2h1bmtzICov
CiAJbnVtX3RicyA9IGl3bF90ZmRfZ2V0X251bV90YnModGZkKTsKIAorCisJSVdMX0VSUih0cmFu
cywgIiVzICBURkQgJXAgVW5tYXAgJXAgVEJzICVkIiwgX19mdW5jX18sIHRmZCwgZG1hX3VubWFw
X2FkZHIobWV0YSwgbWFwcGluZyksIG51bV90YnMpOworCiAJaWYgKG51bV90YnMgPj0gSVdMX05V
TV9PRl9UQlMpIHsKIAkJSVdMX0VSUih0cmFucywgIlRvbyBtYW55IGNodW5rczogJWlcbiIsIG51
bV90YnMpOwogCQkvKiBAdG9kbyBpc3N1ZSBmYXRhbCBlcnJvciwgaXQgaXMgcXVpdGUgc2VyaW91
cyBzaXR1YXRpb24gKi8KQEAgLTIwOSw3ICsyMTIsNyBAQCBzdGF0aWMgdm9pZCBpd2xhZ25fdW5t
YXBfdGZkKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLCBzdHJ1Y3QgaXdsX2NtZF9tZXRhICptZXRh
LAogfQogCiAvKioKLSAqIGl3bGFnbl90eHFfZnJlZV90ZmQgLSBGcmVlIGFsbCBjaHVua3MgcmVm
ZXJlbmNlZCBieSBURkQgW3R4cS0+cS5yZWFkX3B0cl0KKyAqIGl3bGFnbl90eHFfZnJlZV90ZmQg
LSBGcmVlIGFsbCBjaHVua3MgcmVmZXJlbmNlZCBieSBhIFRGRAogICogQHRyYW5zIC0gdHJhbnNw
b3J0IHByaXZhdGUgZGF0YQogICogQHR4cSAtIHR4IHF1ZXVlCiAgKiBAaW5kZXggLSB0aGUgaW5k
ZXggb2YgdGhlIFRGRCB0byBiZSBmcmVlZApAQCAtMjIyLDE3ICsyMjUsMTggQEAgdm9pZCBpd2xh
Z25fdHhxX2ZyZWVfdGZkKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLCBzdHJ1Y3QgaXdsX3R4X3F1
ZXVlICp0eHEsCiAJaW50IGluZGV4LCBlbnVtIGRtYV9kYXRhX2RpcmVjdGlvbiBkbWFfZGlyKQog
ewogCXN0cnVjdCBpd2xfdGZkICp0ZmRfdG1wID0gdHhxLT50ZmRzOworCWludCBpZHggPSBnZXRf
Y21kX2luZGV4KCZ0eHEtPnEsIGluZGV4KTsKIAogCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJnR4cS0+
bG9jayk7CiAKLQlpd2xhZ25fdW5tYXBfdGZkKHRyYW5zLCAmdHhxLT5lbnRyaWVzW2luZGV4XS5t
ZXRhLAorCWl3bGFnbl91bm1hcF90ZmQodHJhbnMsICZ0eHEtPmVudHJpZXNbaWR4XS5tZXRhLAog
CQkJICZ0ZmRfdG1wW2luZGV4XSwgZG1hX2Rpcik7CiAKIAkvKiBmcmVlIFNLQiAqLwogCWlmICh0
eHEtPmVudHJpZXMpIHsKIAkJc3RydWN0IHNrX2J1ZmYgKnNrYjsKIAotCQlza2IgPSB0eHEtPmVu
dHJpZXNbaW5kZXhdLnNrYjsKKwkJc2tiID0gdHhxLT5lbnRyaWVzW2lkeF0uc2tiOwogCiAJCS8q
IENhbiBiZSBjYWxsZWQgZnJvbSBpcnFzLWRpc2FibGVkIGNvbnRleHQKIAkJICogSWYgc2tiIGlz
IG5vdCBOVUxMLCBpdCBtZWFucyB0aGF0IHRoZSB3aG9sZSBxdWV1ZSBpcyBiZWluZwpAQCAtMjQw
LDcgKzI0NCw3IEBAIHZvaWQgaXdsYWduX3R4cV9mcmVlX3RmZChzdHJ1Y3QgaXdsX3RyYW5zICp0
cmFucywgc3RydWN0IGl3bF90eF9xdWV1ZSAqdHhxLAogCQkgKi8KIAkJaWYgKHNrYikgewogCQkJ
aXdsX29wX21vZGVfZnJlZV9za2IodHJhbnMtPm9wX21vZGUsIHNrYik7Ci0JCQl0eHEtPmVudHJp
ZXNbaW5kZXhdLnNrYiA9IE5VTEw7CisJCQl0eHEtPmVudHJpZXNbaWR4XS5za2IgPSBOVUxMOwog
CQl9CiAJfQogfQpAQCAtMjc5LDYgKzI4Myw4IEBAIGludCBpd2xhZ25fdHhxX2F0dGFjaF9idWZf
dG9fdGZkKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLAogCiAJaXdsX3RmZF9zZXRfdGIodGZkLCBu
dW1fdGJzLCBhZGRyLCBsZW4pOwogCisJSVdMX0VSUih0cmFucywgIkFUVEFDSEVEICVkIHRicyB0
byAlZCAgICBURkQgJXAgICAlcCIsIGl3bF90ZmRfZ2V0X251bV90YnModGZkKSwgcS0+d3JpdGVf
cHRyLCB0ZmQsIGFkZHIpOworCiAJcmV0dXJuIDA7CiB9CiAKQEAgLTYxMCw3ICs2MTYsNyBAQCBz
dGF0aWMgaW50IGl3bF9lbnF1ZXVlX2hjbWQoc3RydWN0IGl3bF90cmFucyAqdHJhbnMsIHN0cnVj
dCBpd2xfaG9zdF9jbWQgKmNtZCkKIAkJY21kX2Rlc3QgKz0gY21kLT5sZW5baV07CiAJfQogCi0J
SVdMX0RFQlVHX0hDKHRyYW5zLAorCUlXTF9FUlIodHJhbnMsCiAJCSJTZW5kaW5nIGNvbW1hbmQg
JXMgKCMleCksIHNlcTogMHglMDRYLCAlZCBieXRlcyBhdCAlZFslZF06JWRcbiIsCiAJCXRyYW5z
X3BjaWVfZ2V0X2NtZF9zdHJpbmcodHJhbnNfcGNpZSwgb3V0X2NtZC0+aGRyLmNtZCksCiAJCW91
dF9jbWQtPmhkci5jbWQsIGxlMTZfdG9fY3B1KG91dF9jbWQtPmhkci5zZXF1ZW5jZSksIGNtZF9z
aXplLApAQCAtNjI4LDYgKzYzNCwxMiBAQCBzdGF0aWMgaW50IGl3bF9lbnF1ZXVlX2hjbWQoc3Ry
dWN0IGl3bF90cmFucyAqdHJhbnMsIHN0cnVjdCBpd2xfaG9zdF9jbWQgKmNtZCkKIAogCWl3bGFn
bl90eHFfYXR0YWNoX2J1Zl90b190ZmQodHJhbnMsIHR4cSwKIAkJCQkJcGh5c19hZGRyLCBjb3B5
X3NpemUsIDEpOworCisJSVdMX0VSUih0cmFucywgIiVzLCBNYXBwZWQgJXAgdG8gJXAgVEIgJWQg
IFslZCwgJWRdIiwKKwkJX19mdW5jX18sIG91dF9jbWQtPmhkciwgcGh5c19hZGRyLAorCQlpd2xf
dGZkX2dldF9udW1fdGJzKCZ0eHEtPnRmZHNbcS0+d3JpdGVfcHRyXSksCisJCWlkeCwgcS0+d3Jp
dGVfcHRyKTsKKwogI2lmZGVmIENPTkZJR19JV0xXSUZJX0RFVklDRV9UUkFDSU5HCiAJdHJhY2Vf
YnVmc1swXSA9ICZvdXRfY21kLT5oZHI7CiAJdHJhY2VfbGVuc1swXSA9IGNvcHlfc2l6ZTsKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXRyYW5zLXBjaWUuYyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXRyYW5zLXBjaWUuYwppbmRleCBlMTc2
MWM1Li4zMWJlMDE1IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3
bC10cmFucy1wY2llLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtdHJh
bnMtcGNpZS5jCkBAIC00MzUsOCArNDM1LDkgQEAgc3RhdGljIHZvaWQgaXdsX3R4X3F1ZXVlX3Vu
bWFwKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLCBpbnQgdHhxX2lkKQogCiAJc3Bpbl9sb2NrX2Jo
KCZ0eHEtPmxvY2spOwogCXdoaWxlIChxLT53cml0ZV9wdHIgIT0gcS0+cmVhZF9wdHIpIHsKKwkJ
SVdMX0VSUih0cmFucywgIiVzLCBVTk1BUCAlZFslZF06JWQiLCBfX2Z1bmNfXywgcS0+cmVhZF9w
dHIsIGdldF9jbWRfaW5kZXgocSwgcS0+cmVhZF9wdHIpLCB0eHFfaWQpOwogCQkvKiBUaGUgcmVh
ZF9wdHIgbmVlZHMgdG8gYm91bmQgYnkgcS0+bl93aW5kb3cgKi8KLQkJaXdsYWduX3R4cV9mcmVl
X3RmZCh0cmFucywgdHhxLCBnZXRfY21kX2luZGV4KHEsIHEtPnJlYWRfcHRyKSwKKwkJaXdsYWdu
X3R4cV9mcmVlX3RmZCh0cmFucywgdHhxLCBxLT5yZWFkX3B0ciwKIAkJCQkgICAgZG1hX2Rpcik7
CiAJCXEtPnJlYWRfcHRyID0gaXdsX3F1ZXVlX2luY193cmFwKHEtPnJlYWRfcHRyLCBxLT5uX2Jk
KTsKIAl9Cg==
--e0cb4efe28483bb6e604bf59e926--
