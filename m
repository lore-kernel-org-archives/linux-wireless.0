Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58497 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZFIPko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 11:40:44 -0400
Subject: Re: [PATCH] mac80211: don't use master netdev name
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1244558970.4672.26.camel@johannes.local>
References: <1244557112.4672.20.camel@johannes.local>
	 <1244558869.895.7.camel@mj>  <1244558970.4672.26.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 17:40:44 +0200
Message-Id: <1244562044.3068.19.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > Always use the wiphy name instead.
> > 
> > No objections against the patch.
> > 
> > Maybe we could use wiphy names for the network devices?  That is,
> > wmaster0 would become phy0 and so on.  Using two names for the same
> > thing is confusing.  What's better is that we won't have wmaster0
> > corresponding to phy1 after the driver is reloaded.  We'll have "phy1"
> > in both namespaces.
> > 
> > I wish we could hide those master devices using some "hidden network
> > device" attribute, but it's not happening.
> 
> Actually, the reason I'm posting this patch is that I'm killing the
> mdev.

/me making a happy dance ;)

Regards

Marcel


