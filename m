Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from antispam.upcomillas.es ([130.206.70.245]:43695 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbYDIM6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 08:58:49 -0400
Received: from antispam.upcomillas.es (kurosawa [127.0.0.1])
	by localhost.upcomillas.es (Postfix) with ESMTP id C4F91224CB3
	for <linux-wireless@vger.kernel.org>; Wed,  9 Apr 2008 14:58:48 +0200 (CEST)
Received: from mail1.upco.es (loghost [130.206.70.227])
	by antispam.upcomillas.es (Postfix) with ESMTP id BBC55224C5E
	for <linux-wireless@vger.kernel.org>; Wed,  9 Apr 2008 14:58:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail1.upco.es (Postfix) with ESMTP id AD8C343C79
	for <linux-wireless@vger.kernel.org>; Wed,  9 Apr 2008 14:58:48 +0200 (CEST)
Received: from mail1.upco.es ([127.0.0.1])
	by localhost (mail1 [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 25682-04 for <linux-wireless@vger.kernel.org>;
	Wed, 9 Apr 2008 14:58:48 +0200 (CEST)
Received: from [130.206.71.186] (pern.dea.icai.upco.es [130.206.71.186])
	by mail1.upco.es (Postfix) with ESMTP id 8914843BCD
	for <linux-wireless@vger.kernel.org>; Wed,  9 Apr 2008 14:58:48 +0200 (CEST)
Subject: Re: pull request: wireless-2.6.26 2008-04-08
From: Romano Giannetti <romanol@upcomillas.es>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080408211043.GA17197@tuxdriver.com>
References: <20080408211043.GA17197@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Wed, 09 Apr 2008 14:58:48 +0200
Message-Id: <1207745928.28652.7.camel@pern> (sfid-20080409_135855_288104_160F9ABA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Tue, 2008-04-08 at 17:10 -0400, John W. Linville wrote:
> Dave,
>=20
> Another week, another 50+ patches for 2.6.26...
>=20
> There are the usual libertas, iwlwifi, and b43 (and ssb) updates, plu=
s a
> few other fixes for issues already in net-2.6.26.  There is also some
> movement of files to more convenient places or names.
>=20

Little improvement for my ath5k AR5414 based card. Noe instead of a MAC
error the driver says "ath5k phy0: device not yet supported" and bails
out. Nevertheless, I have seen partial success stories on that list wit=
h
an AR5414... getting nearer? Thank you all!

Romano=20


--=20
Sorry for the disclaimer --- =A1I cannot stop it!



--
La presente comunicaci=F3n tiene car=E1cter confidencial y es para el e=
xclusivo uso del destinatario indicado en la misma. Si Ud. no es el des=
tinatario indicado, le informamos que cualquier forma de distribuci=F3n=
, reproducci=F3n o uso de esta comunicaci=F3n y/o de la informaci=F3n c=
ontenida en la misma est=E1n estrictamente prohibidos por la ley. Si Ud=
=2E ha recibido esta comunicaci=F3n por error, por favor, notif=EDquelo=
 inmediatamente al remitente contestando a este mensaje y proceda a con=
tinuaci=F3n a destruirlo. Gracias por su colaboraci=F3n.

This communication contains confidential information. It is for the exc=
lusive use of the intended addressee. If you are not the intended addre=
ssee, please note that any form of distribution, copying or use of this=
 communication or the information in it is strictly prohibited by law. =
If you have received this communication in error, please immediately no=
tify the sender by reply e-mail and destroy this message. Thank you for=
 your cooperation.=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
