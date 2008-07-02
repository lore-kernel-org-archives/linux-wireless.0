Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:32859 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbYGBCn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 22:43:58 -0400
Message-ID: <486AEBC1.4040903@lwfinger.net> (sfid-20080702_044400_835163_71AE1CE7)
Date: Tue, 01 Jul 2008 21:45:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>	 <200807011227.15805.mb@bu3sch.de>	 <20080701143439.GA6962@khazad-dum.debian.net>	 <1214923097.3462.0.camel@johannes.berg>	 <20080701165036.GB6962@khazad-dum.debian.net>	 <1214931676.3462.5.camel@johannes.berg> <486A65F5.5030909@lwfinger.net>	 <20080701173502.GB24605@khazad-dum.debian.net>	 <486A75C0.3010306@lwfinger.net> <1214947251.28817.15.camel@localhost.localdomain>
In-Reply-To: <1214947251.28817.15.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> 
> No, it's a linux kernel module for HP laptops that talks to BIOS
> routines to get the state of the killswitch on some HP laptops.
> Unfortunately this has to happen through WMI hooks, even on Linux.

I do not have that module configured, thus it cannot get in the way.

Larry

