Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:5359 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZDCNjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 09:39:22 -0400
Received: by yw-out-2324.google.com with SMTP id 5so976658ywb.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 06:39:20 -0700 (PDT)
Message-ID: <49D6117D.9020408@gmail.com> (sfid-20090403_153925_892314_99E9782A)
Date: Fri, 03 Apr 2009 09:39:09 -0400
From: Will Keaney <keaneyw@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Trouble Associating with ath5k on AR5212
References: <49D4C7B3.7010803@gmail.com> <b6c5339f0904020805w5e210c2bl542eadb20ac5d6c7@mail.gmail.com> <49D56445.20502@gmail.com> <20090403020358.GA12406@hash.localnet> <49D571BB.7060406@gmail.com> <20090403122332.GA14853@hash.localnet>
In-Reply-To: <20090403122332.GA14853@hash.localnet>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6CA44B66C51D358E6CB0F83E"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6CA44B66C51D358E6CB0F83E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Bob Copeland wrote:
> On Thu, Apr 02, 2009 at 10:17:31PM -0400, Will Keaney wrote:
>  =20
>> dmesg shows this:
>> [38645.639170] ath5k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) ->=

>> IRQ 17
>> [38645.639199] ath5k 0000:03:00.0: setting latency timer to 64
>> [38645.639342] ath5k 0000:03:00.0: registered as 'phy5'
>> [38645.872038] phy5: Selected rate control algorithm 'minstrel'
>> [38645.882037] Registered led device: ath5k-phy5::rx
>> [38645.882090] Registered led device: ath5k-phy5::tx
>> [38645.882097] ath5k phy5: Atheros AR5414 chip found (MAC: 0xa3, PHY: =
0x61)
>> [38646.133614] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [38667.211026] ath5k phy5: noise floor calibration timeout (5785MHz)
>>
>> I think the key there is the last line.  There is no further output in=

>> dmesg, regardless of what I do in wpa_supplicant.
>>    =20
>
> Probably a red herring, actually -- but yeah, you should be seeing more=

> output as the association process continues.  That is a pretty frequent=

> and harmless error message, here you are scanning and just changed to
> a 5.7 ghz channel for a passive scan.
>
> Are you getting any results at all from scans?  Is ath5k using 100% of
> any cpu?
>  =20
I do get some results on scans, but not as many as with madwifi.  Also,
it reports dramatically different signal strengths than madwifi (though
this may be because madwifi sets my maximun Tx power to 17dBm, and ath5k
sets it to 20).
I don't see any untoward CPU usage when ath5k is loaded.  wpa_supplicant
uses about 40% on one core, give or take.


--------------enig6CA44B66C51D358E6CB0F83E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknWEYIACgkQjfayWCA8dDFpTQCeKYto2fXfrzi7SEISJJQhwA3k
3ZAAmQHm18s9WGqbnNi1zDwEpNbQupo6
=duYm
-----END PGP SIGNATURE-----

--------------enig6CA44B66C51D358E6CB0F83E--
