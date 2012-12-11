Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41792 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab2LKMfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 07:35:33 -0500
Message-ID: <1355229286.3738.137.camel@cumari.coelho.fi> (sfid-20121211_133537_601280_2D18241A)
Subject: Re: wl12xx over spi with no scan results
From: Luciano Coelho <coelho@ti.com>
To: Alberto Garau <Alberto.Garau@inpeco.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ido Yariv" <ido@wizery.com>, Arik Nemtsov <arik@wizery.com>
Date: Tue, 11 Dec 2012 14:34:46 +0200
In-Reply-To: <0294E4ABF3EF28409B75AAF7EAC3D41A0C3606E9@DB3PRD0510MB381.eurprd05.prod.outlook.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-21-git-send-email-arik@wizery.com>
	 <1355159205.3738.63.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C360305@DB3PRD0510MB381.eurprd05.prod.outlook.com>
	 <1355161791.3738.67.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C360609@DB3PRD0510MB381.eurprd05.prod.outlook.com>
	 <1355218436.3738.122.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C36067E@DB3PRD0510MB381.eurprd05.prod.outlook.com>
	 <1355223079.3738.128.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C3606E9@DB3PRD0510MB381.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-11 at 12:28 +0000, Alberto Garau wrote:
> Thanks Luca, 
> 
> configuring 
> 
> board_ref_clock = WL12XX_REFCLOCK_38, /* 38.4 MHz */
> 
> gave me the possibility to scan network but only for an essid on channel1 (delivered from one AP).

Great! This is good progress. :)


> I couldn't scan others essids on other channels (for example channel 6) and I don't know why.
> 
> Have you got any idea about it ?

Next I'd recommend you to start using the iw tool instead of iwlist and
friends, so things are more predictable and I can help you more easily.

--
Luca.

