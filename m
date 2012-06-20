Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab2FTJFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:05:22 -0400
Message-ID: <1340183115.4655.50.camel@jlt3.sipsolutions.net> (sfid-20120620_110527_925538_FD983E2E)
Subject: Re: [PATCH v2] mac80211: initialize sta pointer to avoid
 false-positive warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tony@atomide.com
Date: Wed, 20 Jun 2012 11:05:15 +0200
In-Reply-To: <1340182559.1631.208.camel@cumari.coelho.fi>
References: <1340023971-9754-1-git-send-email-coelho@ti.com>
	 <1340182340.4655.46.camel@jlt3.sipsolutions.net>
	 <1340182559.1631.208.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 11:55 +0300, Luciano Coelho wrote:

> BTW, when you say you applied, does it mean you have pushed to your
> tree? We want to remove some of our mac80211 patches from our internal
> trees and "inherit" them from upstream instead, that's why I'm
> asking. ;)

It may or may not mean that, I've not quite figured out the entire
workflow.

So far, it has basically meant "I'm happy with it and I picked it up
into my (local) git tree". I will also push it into one of the
mac80211/mac80211-next repositories.

However, I make no guarantees that I don't have to rebase those
repositories sometimes, if I were you I wouldn't merge from me right
now, at least until I've figured out my workflow completely...

I do plan on sending a pull request to John every week or so though, and
when I do I've obviously committed to the code :)

johannes

