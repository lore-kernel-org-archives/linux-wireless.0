Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47708 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751424AbYFZRzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 13:55:45 -0400
Subject: Re: RFC: always enable MAC80211_RC_PID?
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Adrian Bunk <bunk@stusta.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20080624124311.GC16021@cs181140183.pp.htv.fi>
References: <20080622125553.GB22539@cs181133002.pp.htv.fi>
	 <43e72e890806220804i347b942claae7b725231afcce@mail.gmail.com>
	 <1214298259.8967.260.camel@johannes.berg>
	 <20080624124311.GC16021@cs181140183.pp.htv.fi>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 19:55:42 +0200
Message-Id: <1214502942.4432.6.camel@localhost> (sfid-20080626_195550_830306_CDA8F6F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just what I remember about the discussion that led to the ugly Makefile.

On Tue, 2008-06-24 at 15:43 +0300, Adrian Bunk wrote:
> 
> Can we get one of either:
> - all selected mac80211 algorithms are built into the mac80211 module or

IIRC, this was originally voted against because this approach would
increase kernel image size or module size unnecessarily.

> - all selected mac80211 algorithms (including the default one) are in
>   their own modules

The argument against this was that there are people who don't compile in
module autoloading, can't figure out what's wrong (in spite of the
syslog message) and complain about wireless not working...

Anyway, I always liked any of the two things you suggested better than
what we have now.

Mattias

