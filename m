Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbXLNMLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 07:11:40 -0500
Subject: Re: [FYI] hostapd with mac80211 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	hostap <hostap@shmoo.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1197512614.6558.224.camel@johannes.berg> (sfid-20071213_113823_799536_82B49721)
References: <1197512614.6558.224.camel@johannes.berg>
	 (sfid-20071213_113823_799536_82B49721)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aXwlPUglRHhIoFsD6tht"
Date: Fri, 14 Dec 2007 12:17:32 +0100
Message-Id: <1197631052.16079.26.camel@johannes.berg> (sfid-20071214_121145_554549_A2C465A1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aXwlPUglRHhIoFsD6tht
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

>  * set_tx_queue_params

Actually, I wonder if any of that should be implemented in the wireless
classifier. Well, what I'm thinking is that we should make mac80211
provide multiqueue netdevs with four queues and then write a new 802.11
classifier that is attached in the sch_fifo qdisc. Then, the queue
parameters could be configured with the 802.11 qdisc.

Tomas, you said you might look into the QoS stuff, any ideas?

johannes

--=-aXwlPUglRHhIoFsD6tht
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2JmS6Vg1VMiehFYAQIioA//QIO0KZfBfHrjZsQuQCXWcyDKhYPXsPF4
d8QEdgPQzGKDs6UO8z8UMQegI5L9dp22/QYNX88f9aTtmm7ZcsNWP/htqR8vW+S1
bUgPfez9kkHcNuU18D9balC8ogFzoBvOek4sMSyZ4NsO3dJ4s+VBsvDK/E/EbjMi
LJCJDaKhIOh/HVw71S3VLHa2mMh/XiQofTyt08lJPRg+fc+ETEyNFVfkDpNXlO0k
NAMGRFjS5tF+vVNB+VlY/WJXB7wfUy7a/0rTqunmt3GfQxFzthyg5gUl7QjZZ/8Y
2EyYQ78FY3cYCG220b2g4QNGTOcI3MfmbeRKBS0iiXVbNR5TFK+PzeNlrvD3rsg2
dOq2EkDxymm2MU47CcOqpWK1jpmBy9UywRwPl39Np65vK25u2HiQ6bdHJA67QeTo
2WQ/pEv8/9k01tVfTlCvBDMQK4TzNu/l8JE7ty/8hRVesy5+3BSc42Gawp5xZRtE
U6je6QlyqlSh/fAJ4FKmVhaFM6jI2Rfrh9FIMhZLiERrRwuyfogVf7qki4k7GNDl
CIWk8/B2Diobsc8BaTUXs7f156aDc1v/0OULnQr7/tBLRpjeIHTWFCiwwj6n5B3S
KXAin7dXnfc1Z5SDKjOl6smg14nhMV6cL24zFzp/T1r1uMsZVoDYYCFxWQpSxOdC
LPDD3mxNzKw=
=z53W
-----END PGP SIGNATURE-----

--=-aXwlPUglRHhIoFsD6tht--

