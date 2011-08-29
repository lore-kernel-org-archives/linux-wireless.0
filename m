Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alcalazamora.dti2.net ([81.24.162.8]:55720 "EHLO
	alcalazamora.dti2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1H2KVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 06:21:49 -0400
Received: from [172.16.16.6] ([81.24.161.20])
	(authenticated user jorge@dti2.net)
	by alcalazamora.dti2.net (alcalazamora.dti2.net [81.24.162.8])
	(MDaemon PRO v12.0.3)
	with ESMTP id md50018366685.msg
	for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 12:15:01 +0200
Message-ID: <4E5B669F.8060605@dti2.net> (sfid-20110829_122152_781604_4A622F10)
Date: Mon, 29 Aug 2011 12:14:55 +0200
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
MIME-Version: 1.0
To: adrian@freebsd.org
CC: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.1] ath9k_hw: fix calibration on 5 ghz
References: <1314605174-66206-1-git-send-email-nbd@openwrt.org> <CAJ-Vmonvcrd49rQbgeyO3HCLxkTbww3mTypR87CuPBiu9uwhHA@mail.gmail.com>
In-Reply-To: <CAJ-Vmonvcrd49rQbgeyO3HCLxkTbww3mTypR87CuPBiu9uwhHA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Reply-To: jorge@dti2.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 29/08/2011 11:01, Adrian Chadd escribió:
> Can we please hold off of this until we know if this is indeed the correct fix?
> 
> Ie, I'm not sure yet whether 5ghz fast clock (which clocks the mac/bb
> like it was doing 2.4ghz) needs the dual ADCs enabled or not.
> It may be that something is being incorrectly disabled when the
> fastclock initvals are being written over the normal 5ghz values.
>uary
> Thanks,

	Hi, I reported this same problem on february, I was using Ubiquiti SR71-15
cards. I've been running them with the same "fix" that Felix has proposed. If
you need a tester for another solution just let me know.

	Regards,
		Jorge
-- 
==============================================================
Jorge Boncompte - Ingenieria y Gestion de RED
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- There is only so much duct tape you can put on something
  before it just becomes a giant ball of duct tape.
==============================================================

