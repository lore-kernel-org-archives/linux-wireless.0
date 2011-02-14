Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14039 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab1BNNqR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 08:46:17 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 05:45:56 -0800
Date: Mon, 14 Feb 2011 19:15:53 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: add monitor interface into PS disable list
Message-ID: <20110214134553.GA31074@vmraj-lnx.users.atheros.com>
References: <1297253799-9688-1-git-send-email-rmanoharan@atheros.com>
 <1297685187.3785.30.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1297685187.3785.30.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 05:36:27PM +0530, Johannes Berg wrote:
> On Wed, 2011-02-09 at 17:46 +0530, Rajkumar Manoharan wrote:
> > PS should be disabled in the presence of monitor interface.
> 
> I'm not really sure -- should it? You can have monitors with no flags to
> do see what you're receiving locally, so I prefer the current behaviour.
I just confued with multi-vif behaviour where we are disabling PS.
> If you really want to monitor everything you pretty much need to
> disconnect anyway, I think?
Fine.

--
Rajkumar
