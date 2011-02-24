Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab1BXOV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 09:21:29 -0500
Subject: Re: IBSS and 802.11i (RSN) with mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: jpo234 <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1298557108.4775.12.camel@jlt3.sipsolutions.net>
References: <loom.20110224T145652-996@post.gmane.org>
	 <1298557108.4775.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 15:21:27 +0100
Message-ID: <1298557287.4775.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-24 at 15:18 +0100, Johannes Berg wrote:
> On Thu, 2011-02-24 at 14:01 +0000, jpo234 wrote:
> 
> > Can somebody please either point me to some existing documentation on the topic 
> > or write a small HOWTO?
> 
> 1) Check that iw reports that you can do it (I just now committed code
>    to iw to report it since you asked, so use git version, which will
>    become 0.9.23 at some point in the future)

FWIW, I think iwlwifi is still the only driver that has hw crypto and
supports it right now.

johannes

