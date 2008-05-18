Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:25390 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYERL3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2008 07:29:23 -0400
Received: by wx-out-0506.google.com with SMTP id h29so1186641wxd.4
        for <linux-wireless@vger.kernel.org>; Sun, 18 May 2008 04:29:21 -0700 (PDT)
Message-ID: <4830130D.6020401@gmail.com> (sfid-20080518_132928_126859_637CD146)
Date: Sun, 18 May 2008 07:29:17 -0400
From: Zappacky <zappacky.lists@gmail.com>
MIME-Version: 1.0
To: =?windows-1252?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Add hooks for firmware debugging
References: <200805172244.35966.mb@bu3sch.de> <200805172324.13818.mb@bu3sch.de>	<69e28c910805171527y4521a9e7n34d1842281234769@mail.gmail.com>	<200805180035.04341.mb@bu3sch.de> <69e28c910805171543u27a542b0nf2ab86e5702660e@mail.gmail.com>
In-Reply-To: <69e28c910805171543u27a542b0nf2ab86e5702660e@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefanik G=E1bor wrote:
>=20
> Another question: is this legal in the US? AFAIK this might conflict
> with FCC regulations. (Not sure about EU.)
>=20


Although I don't claim to be a lawyer, I found this information from=20
http://www.softwarefreedom.org/resources/2007/fcc-sdr-whitepaper.html,=20
which is a translation of the FCC's rules regarding software defined=20
radios (including 802.11 chips).

Snippet 1:

The rules require any manufacturer certifying a device under the new=20
process to take steps to prevent =93unauthorized=94 changes to the soft=
ware=20
on the device that might alter its radio frequency and power parameters=
=20
in a way that takes it out of compliance with the regulations known as=20
=46CC Part 15 regulations.2 The specific technology implemented to=20
accomplish this task is left to the manufacturers seeking certification=
,=20
although the FCC suggests several possible mechanisms that can serve as=
=20
such =93security measures.=943

Snippet 2:

Since software is a representation of a mathematical algorithm, it is=20
not a =93device=94, =93home electronic equipment=94 or a =93home electr=
onic ...=20
system.=9417 Further, there is no precedent for applying the device=20
certification rules to software except as installed as a component of a=
=20
specific hardware device. Indeed, the FCC has explicitly limited the=20
certification requirements to =93hardware-based device[s].=9418 Both of=
=20
these facts make it clear that the FCC rules do not apply to software b=
y=20
itself, but only to hardware-based devices.


What I get out of this, and out of poking in the legal babble, is that=20
as long as our firmware doesn't cause the hardware itself to violate FC=
C=20
specs, we're in the clear. According to Snippet 1, it shouldn't even be=
=20
possible to violate the specifications, but we all know how good=20
manufacturers are at stuff like that ;P.

-Andrew/Zappacky

(IANAL, Proceed at your own risk, etc)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
