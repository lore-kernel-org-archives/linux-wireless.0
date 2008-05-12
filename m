Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alphasky.net ([88.198.0.72]:34757 "EHLO alphasky.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbYELQqo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 12:46:44 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by alphasky.net (Postfix) with ESMTP id 96E2B7FCA2
	for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 18:33:45 +0200 (CEST)
Received: from alphasky.net ([127.0.0.1])
	by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bgT1VPGeFFu7 for <linux-wireless@vger.kernel.org>;
	Mon, 12 May 2008 18:33:43 +0200 (CEST)
Received: from delta (p4FD3FF0E.dip.t-dialin.net [79.211.255.14])
	(Authenticated sender: familiekling@alphasky.net)
	by alphasky.net (Postfix) with ESMTPSA id 785957FCA0
	for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 18:33:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by delta (Postfix) with ESMTP id 95B6B980FD
	for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 18:33:42 +0200 (CEST)
Received: from delta ([127.0.0.1])
	by localhost (delta.familiekling.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QEkxgjcpa63P for <linux-wireless@vger.kernel.org>;
	Mon, 12 May 2008 18:33:40 +0200 (CEST)
Received: from beta.familiekling.de (beta.familiekling.de [192.168.0.1])
	by delta (Postfix) with ESMTP id 0B49C9807A
	for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 18:33:40 +0200 (CEST)
Content-Type: multipart/signed;
	boundary="PGP_Universal_32E4166F_2B9D5851_E086659F_39155FA9";
	protocol="application/pgp-signature";
	micalg=pgp-sha1
MIME-Version: 1.0
Subject: Prism54 support for hostapd
Date: Mon, 12 May 2008 18:33:38 +0200
Message-ID: <008E95D7A227A14BB631EE283904ADF0F10F@beta.familiekling.de> (sfid-20080512_184647_617328_A5BB0C29)
From: "Christoph Kling" <ml@familiekling.de>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--PGP_Universal_32E4166F_2B9D5851_E086659F_39155FA9
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

I am using the prism54 driver from linux 2.6.25.2. The wireless card works =
in master mode but I cannot run hostapd. Error message:

# hostapd -dd /etc/hostapd/hostapd.conf=20
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=3D0
Opening raw packet socket for ifindex 6
ioctl(SIOCGIFINDEX): No such device
prism54 driver initialization failed.
eth2: Unable to setup interface.


Strace has shown that hostapd tries to open eth2ap, which the prism54 drive=
r does not provide. It does work neither with hostapd 0.5.1 nor with 0.6.3 =
(dev).=20

Has there been a change in prism54 that breaks hostapd support? Thank you f=
or your answers.


Regards,
Christoph Kling

--PGP_Universal_32E4166F_2B9D5851_E086659F_39155FA9
Content-Type: application/pgp-signature;
	name="PGP.sig"
Content-Transfer-Encoding: 7BIT
Content-Disposition: attachment;
	filename="PGP.sig"

-----BEGIN PGP SIGNATURE-----
Version: 9.8.1 (Build 2523)

iQA/AwUBSChxY9ZXSqOlH0mLEQL6kwCgnvfdM+wnMOENH5+eAKwYUwNQnMYAoMUc
+lA+SHb+eiUNdUS+kfn8v1L7
=HNVN
-----END PGP SIGNATURE-----

--PGP_Universal_32E4166F_2B9D5851_E086659F_39155FA9--
