Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:26749 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYBKXKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 18:10:00 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3938061fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2008 15:09:58 -0800 (PST)
Message-ID: <47B0D5BD.5040109@gmail.com> (sfid-20080211_231006_702181_CA6C7ED2)
Date: Tue, 12 Feb 2008 01:09:49 +0200
From: =?UTF-8?B?RWRkeSBQZXRyaciZb3I=?= <eddy.petrisor@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: weird issues with b43 - and an oops
References: <47B02CBB.1060406@gmail.com> <200802111520.36105.mb@bu3sch.de>
In-Reply-To: <200802111520.36105.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Monday 11 February 2008 12:08:43 Eddy Petri=C8=99or wrote:
>> Feb 11 03:32:12 bounty kernel: b43-phy0 ERROR: Microcode not respond=
ing
>> Feb 11 03:32:12 bounty kernel: b43-phy0 ERROR: You must go to=20
>> http://linuxwireless.org/en/users/Drivers/b43#devicefirmware and=20
>> download the correct firmware (version 4).
>=20
> Do this.

Already did, as noted in the initial mail, thanks.

>> Feb 11 03:32:12 bounty dhclient: wmaster0: unknown hardware address =
type 801
>> Feb 11 03:32:12 bounty kernel: input: b43-phy0 as /class/input/input=
17
>> Feb 11 03:32:12 bounty kernel: WARNING: at drivers/ssb/main.c:883=20
>> ssb_tmslow_reject_bitmask()
>=20
> And use the b43 driver from wireless-2.6

I assume I must use the 'everything' branch, right?
/me is still waiting for 'clone' to finish

(I hope this kernel doesn't have suspend-to-ram and suspend-to-disk=20
issues, I just got them back with 2.6.24)

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
