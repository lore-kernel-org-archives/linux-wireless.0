Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:45351 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712Ab2FTJHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:07:30 -0400
Received: by lbbgk8 with SMTP id gk8so338028lbb.26
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 02:07:26 -0700 (PDT)
Message-ID: <1340183243.1631.209.camel@cumari.coelho.fi> (sfid-20120620_110733_820496_69287C34)
Subject: Re: [PATCH v2] mac80211: initialize sta pointer to avoid
 false-positive warning
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tony@atomide.com
Date: Wed, 20 Jun 2012 12:07:23 +0300
In-Reply-To: <1340183115.4655.50.camel@jlt3.sipsolutions.net>
References: <1340023971-9754-1-git-send-email-coelho@ti.com>
	 <1340182340.4655.46.camel@jlt3.sipsolutions.net>
	 <1340182559.1631.208.camel@cumari.coelho.fi>
	 <1340183115.4655.50.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 11:05 +0200, Johannes Berg wrote:
> On Wed, 2012-06-20 at 11:55 +0300, Luciano Coelho wrote:
> 
> > BTW, when you say you applied, does it mean you have pushed to your
> > tree? We want to remove some of our mac80211 patches from our internal
> > trees and "inherit" them from upstream instead, that's why I'm
> > asking. ;)
> 
> It may or may not mean that, I've not quite figured out the entire
> workflow.
> 
> So far, it has basically meant "I'm happy with it and I picked it up
> into my (local) git tree". I will also push it into one of the
> mac80211/mac80211-next repositories.
> 
> However, I make no guarantees that I don't have to rebase those
> repositories sometimes, if I were you I wouldn't merge from me right
> now, at least until I've figured out my workflow completely...
> 
> I do plan on sending a pull request to John every week or so though, and
> when I do I've obviously committed to the code :)

Cool, I think I'll wait for your pull then.

--
Luca.

