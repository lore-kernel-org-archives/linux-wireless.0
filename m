Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm17-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.93]:26259 "HELO
	nm17-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753415Ab1IPMMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 08:12:32 -0400
From: Marek Lindner <lindner_marek@yahoo.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: don't allow zero mac bssid to be configured
Date: Fri, 16 Sep 2011 14:12:26 +0200
Cc: linux-wireless@vger.kernel.org
References: <1316102844-29970-1-git-send-email-lindner_marek@yahoo.de> <1316173301.4130.12.camel@jlt3.sipsolutions.net> <1316173745.4130.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1316173745.4130.15.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201109161412.26332.lindner_marek@yahoo.de> (sfid-20110916_141238_776125_E836FA80)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, September 16, 2011 13:49:05 Johannes Berg wrote:
> Fair enough. I take it you're just reporting a bug then.

I can live with that.


> The is_zero_ether_addr() check there means "have we found an IBSS
> already?" and as such must stay. It doesn't mean "do we have a valid
> configuration" at all...

In that case you probably should add a comment to make it obvious or come up 
with a cleaner approach of implementing "have we found an IBSS already?".
But who I am to judge the code ?  :-)

Regards,
Marek
