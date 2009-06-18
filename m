Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47275 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbZFRNpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 09:45:33 -0400
Date: Thu, 18 Jun 2009 09:30:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: push rx status into skb->cb
Message-ID: <20090618133055.GB2738@tuxdriver.com>
References: <1245237180.20613.4.camel@johannes.local> <87d491n3bi.fsf@litku.valot.fi> <1245327565.13790.20.camel@johannes.local> <873a9x90u0.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <873a9x90u0.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 18, 2009 at 03:35:19PM +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> >> [...]
> >> 
> >> >  drivers/net/wireless/wl12xx/rx.c           |    3 -
> >> 
> >> Last night John applied a patch which renamed this to wl1251_rx.c.
> >
> > He actually applied both patches so I'll assume git resolved this.
> 
> Nice. I just love git :)

I do too -- but I resolved this one by hand... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
