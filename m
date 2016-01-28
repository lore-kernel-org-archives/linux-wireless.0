Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54222 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933420AbcA1JuD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 04:50:03 -0500
Message-ID: <1453974601.2217.4.camel@sipsolutions.net> (sfid-20160128_105008_613009_65745A4C)
Subject: Re: [RFC V4 1/2] nl80211: add feature for BSS selection support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 28 Jan 2016 10:50:01 +0100
In-Reply-To: <56A93C65.50204@broadcom.com>
References: <1453813592-5266-1-git-send-email-arend@broadcom.com>
	 <1453813592-5266-2-git-send-email-arend@broadcom.com>
	 <1453816594.2759.70.camel@sipsolutions.net> <56A93C65.50204@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-27 at 22:53 +0100, Arend van Spriel wrote:

> So you mean mapping the explicit structure over the nla_data()?

Yes, see "struct nl80211_sta_flag_update" for example.

> > The RSSI_ADJUST here seems wrong in any case? Should've been
> > NLA_U16
> > now?
> 
> It should have, yes.

Now of course it will have to change for again for the struct :)


johannes
