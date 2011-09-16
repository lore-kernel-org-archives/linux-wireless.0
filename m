Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16.bullet.mail.ukl.yahoo.com ([217.146.183.190]:26565 "HELO
	nm16.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751671Ab1IPDOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 23:14:22 -0400
From: Marek Lindner <lindner_marek@yahoo.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: don't allow zero mac bssid to be configured
Date: Fri, 16 Sep 2011 05:14:16 +0200
Cc: linux-wireless@vger.kernel.org
References: <1316102844-29970-1-git-send-email-lindner_marek@yahoo.de> <1316103698.3992.12.camel@jlt3.sipsolutions.net>
In-Reply-To: <1316103698.3992.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201109160514.16603.lindner_marek@yahoo.de> (sfid-20110916_051428_982315_EEBCD879)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, September 15, 2011 18:21:38 Johannes Berg wrote:
> How is this related to configuration? 

These 'sdata->u.ibss' values are initialized by ieee80211_ibss_join() which is 
called when a user invokes "iw dev wlan0 ibss join".


> Shouldn't the configuration check be in cfg80211 instead?

No idea. I just stumbled over this obvious bug when I scrolled down the code. 
Feel free to propose an alternative patch if you have a better solution.

Cheers,
Marek
