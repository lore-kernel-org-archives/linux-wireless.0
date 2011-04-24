Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40081 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757447Ab1DXP1d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 11:27:33 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 08:27:06 -0700
Message-ID: <4DB4415F.2070707@atheros.com> (sfid-20110424_172736_673294_BE13E979)
Date: Sun, 24 Apr 2011 20:57:27 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"L.Kriara@sms.ed.ac.uk" <L.Kriara@sms.ed.ac.uk>
Subject: Re: [PATCH] mac80211: Add num_stations connected in debugfs
References: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com>	 <1303652185.3603.0.camel@jlt3.sipsolutions.net>	 <4DB4318F.6070801@atheros.com> <1303657150.3603.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1303657150.3603.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 24 April 2011 08:29 PM, Johannes Berg wrote:
> iw wlan0 station dump | grep ... | wc -l
thanks, that  works! I need to divide by 11 :)
