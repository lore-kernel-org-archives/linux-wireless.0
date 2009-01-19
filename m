Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34146 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956AbZASJ1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 04:27:16 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 01:27:16 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18804.18086.697692.203973@gargle.gargle.HOWL> (sfid-20090119_102722_272595_3105CDAE)
Date: Mon, 19 Jan 2009 14:53:50 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] mac80211: Reconfigure beacons after a merge run in IBSS mode
In-Reply-To: <1232355388.3799.12.camel@johannes>
References: <18804.11602.400684.88722@gargle.gargle.HOWL>
	<1232353772.3799.1.camel@johannes>
	<18804.16004.937429.850079@gargle.gargle.HOWL>
	<1232355388.3799.12.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> > Yep, I did remember the earlier discussion, this seemed like a quick fix
> > for my IBSS troubles :)
> 
> :)
> How do you disable beaconing to start with though?

We don't, and it seems to work, except that the beacons have to be reconfigured
on returning to the home channel.

Sujith
