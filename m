Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:37820 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404AbZAEURF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 15:17:05 -0500
Message-ID: <49626AB4.5010907@lwfinger.net> (sfid-20090105_211718_443941_01394CF2)
Date: Mon, 05 Jan 2009 14:16:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Felix Fietkau <nbd@openwrt.org>, Andi Kleen <andi@firstfloor.org>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
References: <20090105050248.GG496@one.firstfloor.org>	 <49620BE5.9030507@openwrt.org>	 <20090105142343.GS496@one.firstfloor.org> <49621C36.70602@openwrt.org>	 <20090105152410.GT496@one.firstfloor.org>	 <49622686.9050005@openwrt.org>	 <20090105163553.GU496@one.firstfloor.org>	 <49623712.4060106@openwrt.org>	 <20090105171105.GW496@one.firstfloor.org>	 <49623CEA.4080407@openwrt.org> <3ace41890901051133t13c827ubcd0416503b7b878@mail.gmail.com>
In-Reply-To: <3ace41890901051133t13c827ubcd0416503b7b878@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> This sounds a bit like what is mentioned in this bug report - (no solution yet,
> but the symptom seem similiar).
> http://bugzilla.kernel.org/show_bug.cgi?id=12131
> 

I think that one is different. If I read the bug report correctly, that one
cannot even keep a full rate of 1 Mb/s.

Larry

