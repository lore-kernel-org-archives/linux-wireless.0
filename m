Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38260 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751569AbXLDU5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 15:57:53 -0500
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Holger Schurig <holgerschurig@gmx.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <200712042150.12050.holgerschurig@gmx.de>
References: <1196622331.7472.4.camel@localhost>
	 <20071204110135.1835a57e@morte> <1196790047.7472.5.camel@localhost>
	 <200712042150.12050.holgerschurig@gmx.de>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 21:57:50 +0100
Message-Id: <1196801870.7472.19.camel@localhost> (sfid-20071204_205757_590650_FA718EA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-12-04 at 21:50 +0100, Holger Schurig wrote:
> > but if we want to make some parameters available for everybody, we
> > cannot rely on module parameters, i.e. when mac80211 is compiled int
> > the kernel.
> 
> It doesn't matter if a something is compiled as a module or if this 
> something is part of a monolithic kernel. The "something" will still 
> get it's /sys/module/SOMETHING/ directory and if it happens to have 
> parameters, a /sys/module/SOMETHING/parameters/ directory.

Thanks, good to know.

> But don't do it for rate control. Maybe you want to have on wlan0 a 
> different rate control than on wlan1. And 
> a /sys/module/SOMETHING/parameters/ exported variables are 
> module-global.

Agreed.

Mattias

