Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:53556 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbYBLHTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 02:19:42 -0500
Received: by fg-out-1718.google.com with SMTP id e21so4025086fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2008 23:19:41 -0800 (PST)
Message-ID: <47B14882.9070703@gmail.com> (sfid-20080212_071945_541009_AB19D470)
Date: Tue, 12 Feb 2008 09:19:30 +0200
From: =?UTF-8?B?RWRkeSBQZXRyaciZb3I=?= <eddy.petrisor@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: weird issues with b43 - and an oops
References: <47B02CBB.1060406@gmail.com> <200802111520.36105.mb@bu3sch.de> <47B0D5BD.5040109@gmail.com>
In-Reply-To: <47B0D5BD.5040109@gmail.com>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eddy Petri=C8=99or wrote:
> Michael Buesch wrote:
>>
>> Do this.
>=20
> Already did, as noted in the initial mail, thanks.
>=20
>>> Feb 11 03:32:12 bounty dhclient: wmaster0: unknown hardware address=
=20
>>> type 801
>>> Feb 11 03:32:12 bounty kernel: input: b43-phy0 as /class/input/inpu=
t17
>>> Feb 11 03:32:12 bounty kernel: WARNING: at drivers/ssb/main.c:883=20
>>> ssb_tmslow_reject_bitmask()
>>
>> And use the b43 driver from wireless-2.6
>=20
> I assume I must use the 'everything' branch, right?
> /me is still waiting for 'clone' to finish

Thanks, this worked.

> (I hope this kernel doesn't have suspend-to-ram and suspend-to-disk=20
> issues, I just got them back with 2.6.24)

Sigh, suspend to disk doesn't work; I'll try to see if, indeed, in=20
2.6.24 it didn't worked. Not sure if I have the time for a bisect.
I'll return with more info, if I will have any news, if not, assume I=20
either fixed this or lost interest in solving it :-/ .

--=20
Regards,
EddyP
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
"Imagination is more important than knowledge" A.Einstein

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
