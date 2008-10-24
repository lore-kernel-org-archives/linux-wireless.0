Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp8-g19.free.fr ([212.27.42.65]:53597 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYJXIrG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 04:47:06 -0400
Message-ID: <49018B87.8070908@free.fr> (sfid-20081024_104712_921855_1BF9AECA)
Date: Fri, 24 Oct 2008 10:47:03 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH 4/5] crda: Updated regulatory information for France	(FR)
References: <cover.1223583376.git.benoit.papillault@free.fr> <48FE399E.6050907@free.fr> <20081022150323.GO6190@tesla> <49000C21.2010808@free.fr> <20081023110746.GA5979@tesla>
In-Reply-To: <20081023110746.GA5979@tesla>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Luis R. Rodriguez a =E9crit :
> On Wed, Oct 22, 2008 at 10:31:13PM -0700, Benoit PAPILLAULT wrote:
>>> 2483.5 - 2454 =3D 29.5 so 29.5 should be the max bandwidth.
>> Not exactly. The maximum power in this band depends on whether we ar=
e
>> indoor or outdoor. If we are indoor, we are allowed to have 20dBm in=
 the
>> whole 2400 - 2454 MHz band and can still use 40MHz bandwidth. Maybe =
I
>> should describe that different?
>>
>>         (2412 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
>>         (2412 - 2454 @ 40), (N/A, 20), NO-INDOOR
>>         (2454 - 2483.5 @ 40) (N/A, 10), NO-INDOOR
>>
>> In fact, this depends on the indoor/outdoor flags issue which can be
>> resolved later.
>=20
> But I wasn't speaking about power, I was speaking about channel
> bandwidth. You cannot fit a 40 MHz channel into the freq range
> 2483.5 - 2454.

The whole band is still 2412-2483.5MHz in both cases (indoor/outdoor),
this is just that different TX power rules apply for frequencies below
2454 MHz and above when used outdoor.

To me, it's valid to have a 40MHz channel centered at 2462 MHz covering
the range [2442, 2482] MHz. When used outdoor, it will be limited to 10
dBm on the whole range.

Regards,
Benoit
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJAYuHOR6EySwP7oIRAseyAKCjiDkOs39MIBnhjA3OQDsgfCJzYQCgr1aA
R9UNky9HVhPQwtl9pwInL88=3D
=3D7Rzj
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
