Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:38855 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZBPRZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 12:25:18 -0500
Date: Mon, 16 Feb 2009 18:25:28 +0100
From: Daniel Wagner <wagi@monom.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, networkmanager-list@gnome.org
Subject: Re: NetworkManager and mac80211_hwsim
Message-ID: <20090216172528.GB29509@toronto053.server4you.de> (sfid-20090216_182523_459480_4E1E5C6A)
References: <20090216160016.GA29509@toronto053.server4you.de> <1234800284.4219.136.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234800284.4219.136.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 05:04:44PM +0100, Johannes Berg wrote:
> On Mon, 2009-02-16 at 17:00 +0100, Daniel Wagner wrote:
> 
> > hotplug_event_begin_add_dev (..., parent_dev = NULL, ...)
> >   net_add(..., parent_dev = NULL, ...)
> >   {
> >   	if (parent_dev == NULL)
> > 		goto error;
> >   }
> > 
> > Before I go deeper into that thing, does someone has
> > an idea what could go wrong here with mac80211_hwsim?
> 
> hwsim phys have no parents in sysfs since they're virtual.

Do you propose to patch hald to handle this situation then?

daniel
