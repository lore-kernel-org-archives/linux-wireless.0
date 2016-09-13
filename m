Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:50650 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750712AbcIMLN7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 07:13:59 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: ath10k mesh + ap + encryption?
Date: Tue, 13 Sep 2016 13:13:49 +0200
Message-ID: <15353347.MUgkgiNHdu@prime> (sfid-20160913_131819_932579_2AC81111)
In-Reply-To: <87h99kjca5.fsf@kamboji.qca.qualcomm.com>
References: <2661831.slnB0LOeVt@prime> <87h99kjca5.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2255089.7oJpvnv0WK"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2255089.7oJpvnv0WK
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday, September 13, 2016 10:59:31 AM CEST Valo, Kalle wrote:
> Simon Wunderlich <sw@simonwunderlich.de> writes:
> > we have done some experiments last week on ath10k, trying to run mesh
> > (802.11s) and access point at the same time, both encrypted.
> > 
> > We have tested a recent LEDE (reboot-1519-g42f559e) but with
> > firmware-5.bin_10.2.4.70.42-2 and the included wpa_supplicant, which gave
> > us a working encrypted 802.11s network. However, starting an AP at the
> > same time didn't work (AP doesn't beacon). This wasn't a problem when
> > 802.11s was running unencrypted.
> > 
> > We also tested version 10.2.4.97 (from codeaurora), which is now default
> > in
> > LEDE. However, this version apparently doesn't support 11s mesh at all
> > (WMI_SERVICE_MESH_11S is disabled in the service map, but cfg/mac80211
> > advertises support).
> > 
> > So here are my questions:
> >  * Did anyone succesfully run AP and mesh, both encrypted at the same
> >  time?
> >  * Do you have any pointers how we could fix this? Could it be fixable in
> >  the> 
> > driver (i.e. not in firmware)?
> > 
> >  * Does anyone have an idea if 11s will be supported in future versions? I
> > 
> > didn't find any changelogs, but having 11s mode no longer in the service
> > map does not make me optimistic.
> 
> Why is LEDE using 10.2.4.97? It seems to be a quite old release and I
> have no knowledge if anyone even tests that firmware branch with ath10k.
> I recommend to only use firmware releases from ath10k-firmware.git as we
> use those internally with ath10k. In any case, don't make any
> assumptions about future from that firmware branch as it's so old.

This was introduced in December 25th, 2015 after some firmware-related 
problems. I'm CC'ing Martin Blumenstingl who suggested this change.

Since then, ath10k is pulling firmware from here (unless ct firmware is used):

https://source.codeaurora.org/quic/qsdk/oss/firmware/ath10k-firmware/plain/
10.2.4/firmware-5.bin_10.2.4.97-1

However, I don't understand the numbering? 10.2.4.97 > 10.2.4.70, but you say 
10.2.4.70.42-2 is more recent? I would have assumed otherwise from the 
numbers. However, 10.2.4.70 has much more sub-revisions. Is there any document 
describing the revisions? I don't understand it at least from this wiki page 
[1].

Thanks!
    Simon

[1] https://wireless.wiki.kernel.org/en/users/Drivers/ath10k/firmware


--nextPart2255089.7oJpvnv0WK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJX199tAAoJEKEr45hCkp6heE4QAMShuxLf2LBMOqVo/T7O2Pk4
NIS9mShBBlARt7076PJUJJ6jejB6blQ3uz/u29KcwQjbj6k/+DuAsNeos6ZaUpMl
JuXdnLPSP6Os8YDy3M1la0ySwrjw/ydN/Y5E7LvkuODRPFdJHG9zQudRJx3GW8ep
fhEQapNqC4ltm05P+/ogD709prROC2DWnjVXXmjiRH6VE54ur02DEaia8Yej9YVQ
Pc0xaX70vuFVsAv3Pqb+S5OQLkMAm6JgRqTx/9ThH/qwWTjCqQqL5IsUUtYN9EFB
ukcK0GsCc+X3mEgmZnIabxdUkKngFoNQb7j5E5gnsNvDWboiGFPnllcEpxyCvG28
ByIXPVpdtb7wW7WURbRc7GAogJMd1ViUJLa/fkAou2ALVWGimoCJno6E4XVod+RE
rsIIPUNyWcWLJv5VyO1JhhX1+6BzW5gV5PtjI0gQrxfvLSYZiP24A/SsaSMtcDrW
/yC+jxx8uilaLJ356HRPNGYhOMCRT/dyp2wO4y0TnJs/JufylP7nOo3G9MOfWCI6
S+Po3fx/8alYebh+Ve0pOO2w07UHWMIb7x0FncZvx7gzjFXX5dRUfeVad08agIF+
ZbVMENQlEyKWL2D+7FsLmZsD4MT5Muy0v8LvwssF7y6CbYze2wILahxZmYo+IbIu
S7enXDws0nkgjPJMUMZ2
=eIFg
-----END PGP SIGNATURE-----

--nextPart2255089.7oJpvnv0WK--
