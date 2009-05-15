Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:56971 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbZEOVZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 17:25:20 -0400
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>, davem@davemloft.net
In-Reply-To: <alpine.LFD.2.01.0905151147520.3343@localhost.localdomain>
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
	 <20090515182131.GA6439@fancy-poultry.org>
	 <20090515183319.GF2773@tuxdriver.com>
	 <alpine.LFD.2.01.0905151147520.3343@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 15 May 2009 14:25:10 -0700
Message-Id: <1242422710.3446.24.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Linus,

> > Unfortunately, I think Dave might have limited availability right now...
> 
> Yeah, I think he's on some Alaskan cruise.
> 
> Should I just pull directly from you this time?

I would have a similar pull request pending for Bluetooth fixes:

	http://marc.info/?l=linux-netdev&m=124209765506433

Regards

Marcel


