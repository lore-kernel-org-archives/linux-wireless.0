Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:53933 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754071AbcISGoE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 02:44:04 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org
Cc: "Pedersen, Thomas" <twp@qca.qualcomm.com>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k mesh + ap + encryption?
Date: Mon, 19 Sep 2016 08:43:56 +0200
Message-ID: <5898628.mmcCycDigQ@prime> (sfid-20160919_084417_033104_4BC39FBB)
In-Reply-To: <1473789271.27738.4.camel@qca.qualcomm.com>
References: <2661831.slnB0LOeVt@prime> <3247815.ey5ZWkP5uX@prime> <1473789271.27738.4.camel@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2820425.r2kv2YZJnq"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2820425.r2kv2YZJnq
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday, September 13, 2016 5:54:38 PM CEST Pedersen, Thomas wrote:
> On Tue, 2016-09-13 at 14:30 +0200, Simon Wunderlich wrote:
> 
> > [...]
> >
> > Thanks for the clarification. We will then stick to the 70's branch
> > then.
> > 
> > Does anyone have pointers for the other questions? :) I would believe
> > hat many 
> > people would be interested in running AP + Mesh encrypted at the same
> > time (at 
> > least in the open source community ...).
> 
> 
> We're testing encrypted AP + Mesh quite successfully right now with
> this firmware: https://github.com/kvalo/ath10k-firmware/commit/307cb46b
> 06661ebd3186723b5002de769c7add83, of course that is for a QCA4019 chip.
> Which chip are you using? I can poke the firmware guys for possibility
> of getting a 10.4.3.2 firmware build for it.

Hi Thomas,

thanks for the hint! We are using an older QCA9882. I assume your firmware will 
not work for this one? If you can poke the firmware guys, that would be great. 
:)

We also want to test the 70.52 firmware version next, maybe there were some 
changes since the .42 we used.

Thanks,
     Simon
--nextPart2820425.r2kv2YZJnq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJX34ksAAoJEKEr45hCkp6hHp4QAIEaCR9yk5w6O7jhSA+kxwPT
8AgwXibVWWvDb4oURxey5SxuvDY2AJ3L35Yk1tvm4FOprrUZaHP+9+yOJrBO7RXw
XCl+oeANjFPugoFHtkxQgzdmgqfYhb4RROCzUH8DEShgr44PK+EZyR8FkVBstVHr
90iooQ6qCQBVlxD3TfZlX4kMlz7jAl+COXkrEYWiCcnB5fH6mMttMoSdWhkNmMaH
S2VbuU/6NDPoSX0YLjEBhuFAvBaS8NUQU3fSGZKuypZqXz9uG5wJ+FC6ky5AEmX2
MlL/MS9jgeHflSvnB3O6l2ST4Gt7e8S4Ftq0G0GkOGYXjjVhK+5rRjbshRimhxNn
gf3qttQXLO3fC50QIxZlVztRhiZoi+JgO3HiQpKTH7gcRCkQJllhUI0aEO+qZHrd
VqV7ExRpX6QBNVmhdpeKiVtW5BUbEg8fwrczdYxGvzhnN9r89RPZyo7pik0x8EId
3eQiKBUssZztAgA+KYp/NSAus3w48B+dvUsIkWboonRcYaebWLOvZWkqQmnN+Vme
/1VEVFNa3sIImYIoS0jRAw+m0n4gilM9GXFK2XPW9SS8DnDc6ffoIrDQieeIG4Xp
VXT59AadhL8566Fjyg8udZGXRXVKnAKJOHZ66BTpL+9G5jLe7+NxtkQ+xkEXAKpP
WtBHyQwElTEjzjLGBm2N
=9jHP
-----END PGP SIGNATURE-----

--nextPart2820425.r2kv2YZJnq--
