Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ic0245.upco.es ([130.206.70.245]:44435 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283AbYAKRqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 12:46:25 -0500
Subject: Re: Testing ath5k driver
From: Romano Giannetti <romanol@upcomillas.es>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <40f31dec0801110856r1d0e04f3i284afb2a3f64f8c1@mail.gmail.com>
References: <1200049360.12702.14.camel@rukbat>
	 <40f31dec0801110856r1d0e04f3i284afb2a3f64f8c1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 11 Jan 2008 18:46:22 +0100
Message-Id: <1200073582.18380.1.camel@rukbat> (sfid-20080111_174627_851945_0B80BEB4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 2008-01-11 at 18:56 +0200, Nick Kossifidis wrote:
> 2008/1/11, Romano Giannetti <romanol@upcomillas.es>:
> >
> >
> > [  312.999107] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 19 (level=
, low) -> IRQ 19
> > [  312.999141] PCI: Setting latency timer of device 0000:06:00.0 to=
 64
> > [  312.999351] ath5k_pci 0000:06:00.0: registered as 'phy0'
> > [  314.048568] ath5k phy0: failed to resume the MAC Chip
> > [  314.048652] ACPI: PCI interrupt for device 0000:06:00.0 disabled
> > [  314.048674] ath5k_pci: probe of 0000:06:00.0 failed with error -=
5
> >
>=20
> It's a known bug in nic_wakeup, i've fixed it but patch is pending du=
e
> to testing. Problem is that even with that fix RF2425 doesn't tx/rx,
> we are currently working with users to fix 2413/2414 support (radio
> revision 0x56) so it'll take a while (tests etc) before we make this
> work.

Ok, understood. Please feel free to ping me if some change goes in and
need testing.=20

Thanks,
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
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
