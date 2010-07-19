Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934486Ab0GSOhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 10:37:46 -0400
Subject: Re: [RFC] mac80211: move QoS-enable to BSS info
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100719183310.28949b46@dhcp-lab-109.englab.brq.redhat.com>
References: <1279280060.3938.23.camel@jlt3.sipsolutions.net>
	 <20100719183310.28949b46@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 16:37:39 +0200
Message-ID: <1279550259.30478.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-19 at 18:33 +0200, Stanislaw Gruszka wrote:
> On Fri, 16 Jul 2010 13:34:20 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > Stanislaw, can you please test this? I have no legacy APs that really
> > don't understand QoS frames. I suppose I could use a sniffer but maybe
> > it's easier for you to just test with the AP you have?
> 
> Patch works with my legacy AP.
> 
> Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>

Great, thanks for testing.

johannes

