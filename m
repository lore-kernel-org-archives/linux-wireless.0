Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48360 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZFGPac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 11:30:32 -0400
Date: Sun, 7 Jun 2009 11:18:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: matthieu castet <castet.matthieu@free.fr>,
	Georgy Berdyshev <codingmaster@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: mac80211 : fix unaligned rx skb
Message-ID: <20090607151842.GB2736@tuxdriver.com>
References: <4A282B92.70609@free.fr> <4A28B3D0.4070201@free.fr> <4A2B8760.10001@free.fr> <200906071126.22323.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200906071126.22323.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 07, 2009 at 11:26:22AM +0200, Michael Buesch wrote:
> On Sunday 07 June 2009 11:24:48 matthieu castet wrote:
> > matthieu castet wrote:

> > > Where are in ieee80211_deliver_skb that is called after 
> > > ieee80211_data_to_8023. So it is not 802.11.
> > > 
> > Do you want more explanation ?
> 
> No reply always means "ok" on this list ;)

Probably true...however, I was hoping to see an ACK from Johannes...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
