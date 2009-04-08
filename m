Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:58113 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765688AbZDHNir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 09:38:47 -0400
Received: by qyk16 with SMTP id 16so174616qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 08 Apr 2009 06:38:46 -0700 (PDT)
Message-ID: <49DCA8E3.3060603@gmail.com> (sfid-20090408_153856_619579_CE8E9C47)
Date: Wed, 08 Apr 2009 09:38:43 -0400
From: Will Keaney <keaneyw@gmail.com>
MIME-Version: 1.0
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [Fwd: Re: Trouble Associating with ath5k on AR5212]
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB4EF7A4CD78AA7E8613334D8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB4EF7A4CD78AA7E8613334D8
Content-Type: multipart/mixed;
 boundary="------------090101030108070700000100"

This is a multi-part message in MIME format.
--------------090101030108070700000100
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Looks like thunderbird chose to send as HTML again...

-------- Original Message --------

Bob Copeland wrote:
> On Mon, Apr 06, 2009 at 10:02:45PM -0400, Will Keaney wrote:
>  =20
>> As before, I didn't see any additional dmesg output from athk, even wi=
th
>> 'dmesg -n7'.
>>    =20
>
> Hmm, you should be seeing association requests in any case.  How are
> you starting the wireless network?  Can you try setting the -dd option
> to wpa_supplicant?
>  =20
I'm starting it by modprobing ath5k or ath_pci, depending on what needs
to be tested.  udev calls Gentoo's init script for the interface that's
created, which starts wpa_supplicant.  I can add debugging flags as well.=

When testing with the guest wireless at work today, I got the attached
error in dmesg.  I only got it once, and haven't been able to reproduce
it, but thought it might be of interest.

Will

--------------090101030108070700000100
Content-Type: text/plain;
 name="error.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="error.txt"

WyA2MjYwLjA1NjE5Nl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsg
NjI2MC4wNTYyMDZdIFdBUk5JTkc6IGF0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aDVrL2Jh
c2UuYzoxMDk5IGF0aDVrX3Rhc2tsZXRfCnJ4KzB4MzgwLzB4NTE2IFthdGg1a10oKQpbIDYy
NjAuMDU2MjEzXSBIYXJkd2FyZSBuYW1lOiA2NDU5Q1RPClsgNjI2MC4wNTYyMThdIGludmFs
aWQgaHdfcml4OiAxYQpbIDYyNjAuMDU2MjIyXSBNb2R1bGVzIGxpbmtlZCBpbjogYXRoNWsg
Ym5lcCByZmNvbW0gbDJjYXAgYmx1ZXRvb3RoIGJyaWRnZSBzdHAgbApsYyBudmlkaWEoUCkg
Y3B1ZnJlcV9vbmRlbWFuZCBvc3NfdXNiIG9zc19oZGF1ZGlvIG9zc2NvcmUgZnVzZSBjcHVm
cmVxX2NvbnNlcnZhdAppdmUgYWNwaV9jcHVmcmVxIGZyZXFfdGFibGUgaTJjX2k4MDEgaTJj
X2NvcmUgdmlkZW8gb3V0cHV0IHJ0YyB0aGVybWFsIGUxMDAwZSBwYwpzcGtyIHByb2Nlc3Nv
ciBidXR0b24gYmF0dGVyeSBhYyBldmRldiBbbGFzdCB1bmxvYWRlZDogd2xhbl0KWyA2MjYw
LjA1NjI5N10gUGlkOiAwLCBjb21tOiBzd2FwcGVyIFRhaW50ZWQ6IFAgICAgICAgICAgIDIu
Ni4yOS13bC1kaXJ0eSAjMTAKWyA2MjYwLjA1NjMwM10gQ2FsbCBUcmFjZToKWyA2MjYwLjA1
NjMwOF0gIDxJUlE+ICBbPGZmZmZmZmZmODAyM2FhYTM+XSB3YXJuX3Nsb3dwYXRoKzB4ZDMv
MHgxMGYKWyA2MjYwLjA1NjMzNF0gIFs8ZmZmZmZmZmY4MDQxOTFkNz5dID8gc3luYXB0aWNz
X3Byb2Nlc3NfYnl0ZSsweDZlMy8weDcwMApbIDYyNjAuMDU2MzQ0XSAgWzxmZmZmZmZmZjgw
NGZlYjRmPl0gPyBfc3Bpbl9sb2NrX2lycXNhdmUrMHgxOC8weDM0ClsgNjI2MC4wNTYzNTJd
ICBbPGZmZmZmZmZmODA0ZmVkMzQ+XSA/IF9zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4MTIv
MHgyYgpbIDYyNjAuMDU2MzYyXSAgWzxmZmZmZmZmZjgwMzNkMGUzPl0gPyBtYXBfc2luZ2xl
KzB4MTg2LzB4MjA3ClsgNjI2MC4wNTYzNzFdICBbPGZmZmZmZmZmODAzM2NhMjU+XSA/IHN3
aW90bGJfdmlydF90b19idXMrMHgxZi8weDIzClsgNjI2MC4wNTYzODJdICBbPGZmZmZmZmZm
ODAyMjI4ZWE+XSA/IHN3aW90bGJfbWFwX3NpbmdsZV9waHlzKzB4MC8weDE4ClsgNjI2MC4w
NTYzOTBdICBbPGZmZmZmZmZmODA0ZmViNGY+XSA/IF9zcGluX2xvY2tfaXJxc2F2ZSsweDE4
LzB4MzQKWyA2MjYwLjA1NjM5OF0gIFs8ZmZmZmZmZmY4MDRmZWQzND5dID8gX3NwaW5fdW5s
b2NrX2lycXJlc3RvcmUrMHgxMi8weDJiClsgNjI2MC4wNTY0MDZdICBbPGZmZmZmZmZmODAz
M2NlMDk+XSA/IHVubWFwX3NpbmdsZSsweGQ4LzB4ZTEKWyA2MjYwLjA1NjQxNV0gIFs8ZmZm
ZmZmZmY4MDMzY2Y0Nj5dID8gc3dpb3RsYl91bm1hcF9zaW5nbGVfYXR0cnMrMHg1Ni8weDVm
ClsgNjI2MC4wNTY0MzRdICBbPGZmZmZmZmZmYTA5NmU0OWE+XSBhdGg1a190YXNrbGV0X3J4
KzB4MzgwLzB4NTE2IFthdGg1a10KWyA2MjYwLjA1NjQ0NF0gIFs8ZmZmZmZmZmY4MDIzZjRi
OT5dIHRhc2tsZXRfYWN0aW9uKzB4YmMvMHgxMjYKWyA2MjYwLjA1NjQ1Ml0gIFs8ZmZmZmZm
ZmY4MDIzZmUxMT5dIF9fZG9fc29mdGlycSsweDYwLzB4MTBiClsgNjI2MC4wNTY0NjFdICBb
PGZmZmZmZmZmODAyMGQxZWM+XSBjYWxsX3NvZnRpcnErMHgxYy8weDI4ClsgNjI2MC4wNTY0
NjldICBbPGZmZmZmZmZmODAyMGU3N2M+XSBkb19zb2Z0aXJxKzB4MzQvMHg3NgpbIDYyNjAu
MDU2NDc3XSAgWzxmZmZmZmZmZjgwMjNmYjQ0Pl0gaXJxX2V4aXQrMHgzNi8weDdlClsgNjI2
MC4wNTY0ODRdICBbPGZmZmZmZmZmODAyMGU5ZmI+XSBkb19JUlErMHhkYS8weDEwYgpbIDYy
NjAuMDU2NDkyXSAgWzxmZmZmZmZmZjgwMjBjYTkzPl0gcmV0X2Zyb21faW50cisweDAvMHhh
ClsgNjI2MC4wNTY0OTddICA8RU9JPiAgWzxmZmZmZmZmZmEwMDIxNWYzPl0gPyBhY3BpX2lk
bGVfZW50ZXJfYm0rMHgyZWMvMHgzNzIgW3ByCm9jZXNzb3JdClsgNjI2MC4wNTY1MzFdICBb
PGZmZmZmZmZmYTAwMjE1ZTk+XSA/IGFjcGlfaWRsZV9lbnRlcl9ibSsweDJlMi8weDM3MiBb
cHJvY2Vzc29yCl0KWyA2MjYwLjA1NjU0MV0gIFs8ZmZmZmZmZmY4MDI1Nzc1OT5dID8gdGlj
a19ub2h6X2dldF9zbGVlcF9sZW5ndGgrMHgxYS8weDMxClsgNjI2MC4wNTY1NTFdICBbPGZm
ZmZmZmZmODA0MWY5ZDA+XSA/IGNwdWlkbGVfaWRsZV9jYWxsKzB4OTkvMHhkMQpbIDYyNjAu
MDU2NTU5XSAgWzxmZmZmZmZmZjgwMjBiMjE0Pl0gPyBjcHVfaWRsZSsweDRmLzB4YTcKWyA2
MjYwLjA1NjU2OF0gIFs8ZmZmZmZmZmY4MDRlZGU3MT5dID8gcmVzdF9pbml0KzB4NzUvMHg3
NwpbIDYyNjAuMDU2NTc1XSAtLS1bIGVuZCB0cmFjZSBlNzc3NjRlZTA4NTE2ZmViIF0tLS0K

--------------090101030108070700000100
Content-Type: application/pgp-signature;
 name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0KVmVyc2lvbjogR251UEcgdjIuMC4xMSAo
R05VL0xpbnV4KQpDb21tZW50OiBVc2luZyBHbnVQRyB3aXRoIE1vemlsbGEgLSBodHRwOi8v
ZW5pZ21haWwubW96ZGV2Lm9yZwoKaUVZRUFSRUNBQVlGQWtuY3ArTUFDZ2tRamZheVdDQThk
REZ0T2dDZll6c2pibDBtTDRhdFltalprcWNFbHIzaQpxMDBBbkE1ZUUyLzVBdkZJTG1Qcnl1
THRSTVMrVk4xaAo9RkVWTwotLS0tLUVORCBQR1AgU0lHTkFUVVJFLS0tLS0KCg==
--------------090101030108070700000100--

--------------enigB4EF7A4CD78AA7E8613334D8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkncqOMACgkQjfayWCA8dDG4BwCfWOZOQVekdT+HHyCG4dY9G2Wj
Ed0AnjUoX108wNMEWHow/+tOoslXY7L2
=UIqX
-----END PGP SIGNATURE-----

--------------enigB4EF7A4CD78AA7E8613334D8--
