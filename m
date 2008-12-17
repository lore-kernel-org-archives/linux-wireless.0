Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4636 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYLQSYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 13:24:08 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
Date: Wed, 17 Dec 2008 13:21:38 -0500
Message-Id: <20081217174244.M36761@bobcopeland.com> (sfid-20081217_192411_540364_581ACD3B)
In-Reply-To: <1229354532.12163.24.camel@localhost.localdomain>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com> <1229336057.4471.9.camel@johannes.berg> <1229354532.12163.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 15 Dec 2008 10:22:12 -0500, Dan Williams wrote
> Could be udev event ordering?  We do need to track this down, otherwise
> stuff simply won't work when we come back.  

Sorry for not following up on this so far; I don't usually have a lot
of time on weeknights.  I haven't done any exhaustive testing yet but
so far, I don't see anything having to do with networking in udev 
monitor, just input, cpus, and virtual consoles.

logs here: http://bobcopeland.com/kernel/wl/ {udev,dbus,hal}.log

Running pm-suspend from pm-utils directly also triggers the problem, 
so that would seem to excuse gnome-power-manager at least.

-- 
Bob Copeland %% www.bobcopeland.com


