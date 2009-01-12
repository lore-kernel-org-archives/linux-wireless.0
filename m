Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc4-s32.blu0.hotmail.com ([65.55.111.171]:24922 "EHLO
	blu0-omc4-s32.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbZALGhQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 01:37:16 -0500
Message-ID: <BLU129-W353904E1AB1EEE7AC28C7D80D80@phx.gbl> (sfid-20090112_073722_769047_71C8194D)
From: Jayant Sane <jayant_sane@hotmail.com>
To: <larry.finger@lwfinger.net>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: Newbie question on 2.6.28-rc8-wl
Date: Mon, 12 Jan 2009 06:37:15 +0000
In-Reply-To: <496A27FA.5030508@lwfinger.net>
References: <BLU129-W39120C9D5D733AC53C210180DB0@phx.gbl>
 <496A27FA.5030508@lwfinger.net>
Content-Type: text/plain; charset=Windows-1252
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Thank you.

Again pardon my ignorance here..

It seems that I can either get 2.6.28-wl or 2.6.28-rc8 per your suggest=
ions below but not 2.6.28-rc8-wl

And I know it is possible to have the kernel version reported as 2.6.28=
-rc8-wl.  How can I get that?

thx
Jay

> Date: Sun, 11 Jan 2009 11:10:18 -0600
> From: Larry.Finger@lwfinger.net
> To: jayant_sane@hotmail.com
> CC: linux-wireless@vger.kernel.org
> Subject: Re: Newbie question on 2.6.28-rc8-wl
>=20
> Jayant Sane wrote:
>> Bear with a miserable newbie...=20
>> =20
>> I have been asked to compile against the 2.6.28-rc8-wl version of ke=
rnel (as printed by uname -r). How and where can I get this specific ke=
rnel version from?=20
>> =20
>> I figured how to get the patch for 2.6.28-rc8 but the "-wl" part stu=
mps me.=20
>=20
> That is the kernel from the wireless-testing git tree. The only way t=
o
> get it is to install the git package from your distro and issue the
> command
>=20
> git clone \
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testi=
ng.git
>=20
>=20
> Be aware that the download is roughly 200 MB. In addition, the above
> will get you 2.6.28-wl. If you really need -rc8 (which I doubt), then
> you will need to issue the additional command
>=20
> git checkout v2.6.28-rc8
>=20
> The -wl part is not needed here.
>=20
> Larry
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_________________________________________________________________
Windows Live=99 Hotmail=AE: Chat. Store. Share. Do more with mail.=20
http://windowslive.com/howitworks?ocid=3DTXT_TAGLM_WL_t1_hm_justgotbett=
er_howitworks_012009--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
