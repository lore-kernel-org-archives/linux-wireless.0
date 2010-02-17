Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:57128 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933728Ab0BQKI5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 05:08:57 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 3792E81802F
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 11:08:51 +0100 (CET)
Received: from tele (qrm29-1-82-245-201-222.fbx.proxad.net [82.245.201.222])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 39915818184
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 11:08:49 +0100 (CET)
Date: Wed, 17 Feb 2010 11:08:55 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Add Belkin / Accton 083a:f503
Message-ID: <20100217110855.1b626214@tele>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/OI8P7QlbvNbSl8TRp12EFyx"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--MP_/OI8P7QlbvNbSl8TRp12EFyx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello Michael,

I have 2 wifi dongles named Belkin FD7050E ver 1010ec.

They used to work with ndiswrapper, either with ehci_hcd or ohci_hcd
(not the same on 2 different machines! - note that the ms-win driver
often crashed windows XP when I still used it).

I just added the vend:prod in the p54usb driver which comes in
linux-2.6.32-3 and it works fine on a 686 with ehci_hcd (but not with
ohci_hcd).

May you apply the attached patch to the kernel?

Thanks.

--=20
Ken ar c'henta=C3=B1	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/OI8P7QlbvNbSl8TRp12EFyx
Content-Type: application/octet-stream; name=accton.pat
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=accton.pat

cDU0OiBBZGQgdGhlIEJlbGtpbiAoQWNjdG9uKSBGRDcwNTBFIHZlciAxMDEwZWMuCgpTaWduZWQt
b2ZmLWJ5OiBKZWFuLUZyYW7Dp29pcyBNb2luZSA8bW9pbmVqZkBmcmVlLmZyPgoKLS0tIGxpbnV4
LTIuNi4zMi4zL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3A1NC9wNTR1c2IuYy5vcmlnCTIwMTAtMDEt
MDcgMDA6MDc6NDUuMDAwMDAwMDAwICswMTAwCisrKyBsaW51eC0yLjYuMzIuMy9kcml2ZXJzL25l
dC93aXJlbGVzcy9wNTQvcDU0dXNiLmMJMjAxMC0wMi0xNiAyMDozMTozMy4wMDAwMDAwMDAgKzAx
MDAKQEAgLTYwLDYgKzYwLDcgQEAKIAl7VVNCX0RFVklDRSgweDA2YjksIDB4MDEyMSl9LAkvKiBU
aG9tc29uIFNwZWVkVG91Y2ggMTIxZyAqLwogCXtVU0JfREVWSUNFKDB4MDcwNywgMHhlZTEzKX0s
ICAgLyogU01DIDI4NjJXLUcgdmVyc2lvbiAyICovCiAJe1VTQl9ERVZJQ0UoMHgwODNhLCAweDQ1
MjEpfSwgICAvKiBTaWVtZW5zIEdpZ2FzZXQgVVNCIEFkYXB0ZXIgNTQgdmVyc2lvbiAyICovCisJ
e1VTQl9ERVZJQ0UoMHgwODNhLCAweGY1MDMpfSwJLyogQWNjdG9uIEZENzA1MEUgdmVyIDEwMTBl
YyAgKi8KIAl7VVNCX0RFVklDRSgweDA4NDYsIDB4NDI0MCl9LAkvKiBOZXRnZWFyIFdHMTExICh2
MikgKi8KIAl7VVNCX0RFVklDRSgweDA5MTUsIDB4MjAwMCl9LAkvKiBDb2hpYmEgUHJvdG8gYm9h
cmQgKi8KIAl7VVNCX0RFVklDRSgweDA5MTUsIDB4MjAwMil9LAkvKiBDb2hpYmEgUHJvdG8gYm9h
cmQgKi8K

--MP_/OI8P7QlbvNbSl8TRp12EFyx--
