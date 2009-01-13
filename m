Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:49813 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbZAMOKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 09:10:34 -0500
Received: by ewy10 with SMTP id 10so26036ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 06:10:31 -0800 (PST)
Message-ID: <2d0a357f0901130610y493936cp6b5ebf16da5d26d5@mail.gmail.com> (sfid-20090113_151039_254167_DF5275A0)
Date: Tue, 13 Jan 2009 15:10:31 +0100
From: "Sedat Dilek" <sedat.dilek@googlemail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [master-2009-01-12] compiler-error in 'drivers/net/irda/donauboe.c'
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <496BF4DB.2050603@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_202453_2087334.1231855831175"
References: <2d0a357f0901121657s1ea091b6m824e8f939be2d51d@mail.gmail.com>
	 <496BE899.7010406@oracle.com>
	 <2d0a357f0901121715y2aedbeecs9819688f275df25c@mail.gmail.com>
	 <496BF076.7000601@oracle.com>
	 <2d0a357f0901121754y16806d8cm59f61f74626c6a50@mail.gmail.com>
	 <496BF4DB.2050603@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_202453_2087334.1231855831175
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Randy,

I agree with you that it is not the job of the wl-tree to fix issues
from other dev-branches.
Speaking as an end-user, latest wl.git was not compilable with my
kernel-dotconfig.

Just to give a feedback:
wl.git (master-2009-01-12) + 2.6.29-rc1-git3 was compilable and it's
running now.

Kind Regards,
Sedat

P.S.: Additional Informations see attached txt-file.

On Tue, Jan 13, 2009 at 2:56 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Sedat Dilek wrote:
>> Oh cool and thank you for the information!
>> Finally, it will be in 2.6.29-rc1-git3 then :-).
>> Anyway, it would be nice to have a wl.git-tree which is compilable
>> concerning net-* stuff.
>
> That's not the job of the wireless tree(s).
> Sounds like you want one of the netdev trees instead.
>
>> But, it's hard to expect such thing from a very early rc1-kernel :).
>>
>> -SD
>>
>> On Tue, Jan 13, 2009 at 2:37 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> Sedat Dilek wrote:
>>>> No, it's not mainline - I checked 2.6.29-rc1-git{1|2}.
>>>> But, it is in net-2.6.git [1] if you mean that by mainline :).
>>>>
>>>> -SD
>>>>
>>>> [1] irda: fix incomplete conversation to internal stats
>>>> http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=216c32d4407ea6951d6832773fdb3de058e12c62
>>>>
>>>> On Tue, Jan 13, 2009 at 2:04 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>>> Sedat Dilek wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I could not compile latest wl.git due to problems in
>>>>>> 'drivers/net/irda/donauboe.c'.
>>>>>> A fix and description is given in [1].
>>>>>> Hope this helps other people.
>>>>>>
>>>>>> Regards,
>>>>>> Sedat
>>>>>>
>>>>>> [1] http://patchwork.kernel.org/patch/1791/
>>>>> The patch was just merged into mainline.
>>> I mean that it was just merged minutes ago:
>>>
>>> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=216c32d4407ea6951d6832773fdb3de058e12c62
>>> Commit:     216c32d4407ea6951d6832773fdb3de058e12c62
>>> Parent:     c59765042f53a79a7a65585042ff463b69cb248c
>>> Author:     Alexander Beregalov <a.beregalov@gmail.com>
>>> AuthorDate: Thu Jan 8 16:42:08 2009 -0800
>>> Committer:  David S. Miller <davem@davemloft.net>
>>> CommitDate: Sun Jan 11 00:01:31 2009 -0800
>>>
>>>    irda: fix incomplete conversation to internal stats
>>>
>>>    Fix for commit af0490810c (irda: convert to internal stats)
>
>
> --
> ~Randy
>

------=_Part_202453_2087334.1231855831175
Content-Type: text/plain; name=report_iwl3945_2629rc1git3.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpwn4otr0
Content-Disposition: attachment; filename=report_iwl3945_2629rc1git3.txt

IyBkcGtnIC1sIHwgZ3JlcCBsaW51eC1pbWFnZSB8IGdyZXAgMi42LjI5CmlpICBsaW51eC1pbWFn
ZS0yLjYuMjktcmMxLWdpdDMtd2wtZ2NjNDQgICAgICAgICAgICAgICAgICAyLjYuMjl+cmMxK2dp
dDMrd2x+Z2l0MjAwOTAxMTIuMjY5MjQ1Yn5kaWxlWCsxIExpbnV4IGtlcm5lbCBiaW5hcnkgaW1h
Z2UgZm9yIHZlcnNpb24gMi42LjI5LXJjMS1naXQzLXcKCiMgY2F0IC9wcm9jL3ZlcnNpb24gCkxp
bnV4IHZlcnNpb24gMi42LjI5LXJjMS1naXQzLXdsLWdjYzQ0IChzZEBzZWR1eGJveCkgKGdjYyB2
ZXJzaW9uIDQuNC4wIDIwMDkwMTA3IChleHBlcmltZW50YWwpIFt0cnVuayByZXZpc2lvbiAxNDMx
NzBdIChEZWJpYW4gMjAwOTAxMDctMSkgKSAjMSBTTVAgUFJFRU1QVCBUdWUgSmFuIDEzIAoxNDow
ODo0NyBDRVQgMjAwOQoKIyBkcGtnIC1sIHwgZ3JlcCB3cGEKaWkgIHdwYWd1aSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDAuNi43LTArYzAuc2lkdXguMSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgZ3JhcGhpY2FsIHVzZXIgaW50ZXJmYWNlIGZvciB3
cGFfc3VwcGxpY2FudAppaSAgd3Bhc3VwcGxpY2FudCAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgMC42LjctMCtjMC5zaWR1eC4xICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBjbGllbnQgc3VwcG9ydCBmb3IgV1BBIGFuZCBXUEEyIChJRUVFIDgwMi4xMWkpCgojIGRt
ZXNnIHwgZ3JlcCBpd2wKaXdsMzk0NTogSW50ZWwoUikgUFJPL1dpcmVsZXNzIDM5NDVBQkcvQkcg
TmV0d29yayBDb25uZWN0aW9uIGRyaXZlciBmb3IgTGludXgsIDEuMi4yNmtkcwppd2wzOTQ1OiBD
b3B5cmlnaHQoYykgMjAwMy0yMDA5IEludGVsIENvcnBvcmF0aW9uCml3bDM5NDUgMDAwMDoxMDow
MC4wOiBQQ0kgSU5UIEEgLT4gR1NJIDE3IChsZXZlbCwgbG93KSAtPiBJUlEgMTcKaXdsMzk0NSAw
MDAwOjEwOjAwLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NAppd2wzOTQ1IDAwMDA6MTA6
MDAuMDogVHVuYWJsZSBjaGFubmVsczogMTMgODAyLjExYmcsIDIzIDgwMi4xMWEgY2hhbm5lbHMK
aXdsMzk0NSAwMDAwOjEwOjAwLjA6IERldGVjdGVkIEludGVsIFdpcmVsZXNzIFdpRmkgTGluayAz
OTQ1QUJHCml3bDM5NDUgMDAwMDoxMDowMC4wOiBQQ0kgSU5UIEEgZGlzYWJsZWQKd21hc3RlcjAg
KGl3bDM5NDUpOiBub3QgdXNpbmcgbmV0X2RldmljZV9vcHMgeWV0CnBoeTA6IFNlbGVjdGVkIHJh
dGUgY29udHJvbCBhbGdvcml0aG0gJ2l3bC0zOTQ1LXJzJwp3bGFuMCAoaXdsMzk0NSk6IG5vdCB1
c2luZyBuZXRfZGV2aWNlX29wcyB5ZXQKaXdsMzk0NSAwMDAwOjEwOjAwLjA6IFBDSSBJTlQgQSAt
PiBHU0kgMTcgKGxldmVsLCBsb3cpIC0+IElSUSAxNwppd2wzOTQ1IDAwMDA6MTA6MDAuMDogcmVz
dG9yaW5nIGNvbmZpZyBzcGFjZSBhdCBvZmZzZXQgMHgxICh3YXMgMHgxMDAwMDIsIHdyaXRpbmcg
MHgxMDAwMDYpCml3bDM5NDUgMDAwMDoxMDowMC4wOiBpcnEgMjkgZm9yIE1TSS9NU0ktWAppd2wz
OTQ1IDAwMDA6MTA6MDAuMDogZmlybXdhcmU6IHJlcXVlc3RpbmcgaXdsd2lmaS0zOTQ1LTIudWNv
ZGUKaXdsMzk0NSAwMDAwOjEwOjAwLjA6IGxvYWRlZCBmaXJtd2FyZSB2ZXJzaW9uIDE1LjI4LjIu
OApSZWdpc3RlcmVkIGxlZCBkZXZpY2U6IGl3bC1waHkwOnJhZGlvClJlZ2lzdGVyZWQgbGVkIGRl
dmljZTogaXdsLXBoeTA6YXNzb2MKUmVnaXN0ZXJlZCBsZWQgZGV2aWNlOiBpd2wtcGh5MDpSWApS
ZWdpc3RlcmVkIGxlZCBkZXZpY2U6IGl3bC1waHkwOlRYCgojIGRtZXNnIHwgZ3JlcCB3bGFuMAp3
bGFuMCAoaXdsMzk0NSk6IG5vdCB1c2luZyBuZXRfZGV2aWNlX29wcyB5ZXQKQUREUkNPTkYoTkVU
REVWX1VQKTogd2xhbjA6IGxpbmsgaXMgbm90IHJlYWR5CndsYW4wOiBhdXRoZW50aWNhdGUgd2l0
aCBBUCAwMDowNDowZTplNDowMDozZAp3bGFuMDogYXV0aGVudGljYXRlZAp3bGFuMDogYXNzb2Np
YXRlIHdpdGggQVAgMDA6MDQ6MGU6ZTQ6MDA6M2QKd2xhbjA6IFJYIEFzc29jUmVzcCBmcm9tIDAw
OjA0OjBlOmU0OjAwOjNkIChjYXBhYj0weDQxMSBzdGF0dXM9MCBhaWQ9MSkKd2xhbjA6IGFzc29j
aWF0ZWQKQUREUkNPTkYoTkVUREVWX0NIQU5HRSk6IHdsYW4wOiBsaW5rIGJlY29tZXMgcmVhZHkK
d2xhbjA6IG5vIElQdjYgcm91dGVycyBwcmVzZW50CgojIGl3Y29uZmlnIHdsYW4wCndsYW4wICAg
ICBJRUVFIDgwMi4xMWFiZyAgTW9kZTpNYW5hZ2VkICBGcmVxdWVuY3k6Mi40MzIgR0h6ICAKICAg
ICAgICAgIEFjY2VzcyBQb2ludDogMDA6MDQ6MEU6RTQ6MDA6M0QgICBCaXQgUmF0ZT01NCBNYi9z
ICAgVHgtUG93ZXI9MTUgZEJtICAgCiAgICAgICAgICBSZXRyeSBtaW4gbGltaXQ6NyAgIFJUUyB0
aHI6b2ZmICAgRnJhZ21lbnQgdGhyPTIzNTIgQiAgIAogICAgICAgICAgRW5jcnlwdGlvbiBrZXk6
bXlTZWNyZXRFbmNLZXkgWzNdICAgU2VjdXJpdHkgbW9kZTpvcGVuCiAgICAgICAgICBQb3dlciBN
YW5hZ2VtZW50Om9mZgogICAgICAgICAgTGluayBRdWFsaXR5PTc3LzEwMCAgU2lnbmFsIGxldmVs
Oi01NyBkQm0gIE5vaXNlIGxldmVsPS0xMjcgZEJtCiAgICAgICAgICBSeCBpbnZhbGlkIG53aWQ6
MCAgUnggaW52YWxpZCBjcnlwdDowICBSeCBpbnZhbGlkIGZyYWc6MAogICAgICAgICAgVHggZXhj
ZXNzaXZlIHJldHJpZXM6MCAgSW52YWxpZCBtaXNjOjAgICBNaXNzZWQgYmVhY29uOjAKCiMgaXdj
b25maWcgd2xhbjAgcG93ZXIgb24KRXJyb3IgZm9yIHdpcmVsZXNzIHJlcXVlc3QgIlNldCBQb3dl
ciBNYW5hZ2VtZW50IiAoOEIyQykgOgogICAgU0VUIGZhaWxlZCBvbiBkZXZpY2Ugd2xhbjAgOyBP
cGVyYXRpb24gbm90IHN1cHBvcnRlZC4K
------=_Part_202453_2087334.1231855831175--
