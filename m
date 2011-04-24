Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab1DXPcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 11:32:04 -0400
Subject: Re: [PATCH] mac80211: Add num_stations connected in debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"L.Kriara@sms.ed.ac.uk" <L.Kriara@sms.ed.ac.uk>
In-Reply-To: <4DB4415F.2070707@atheros.com>
References: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com>
	 <1303652185.3603.0.camel@jlt3.sipsolutions.net>
	 <4DB4318F.6070801@atheros.com>
	 <1303657150.3603.1.camel@jlt3.sipsolutions.net>
	 <4DB4415F.2070707@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 17:32:00 +0200
Message-ID: <1303659120.3603.3.camel@jlt3.sipsolutions.net> (sfid-20110424_173209_239821_B470BD23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-24 at 20:57 +0530, Mohammed Shafi wrote:
> On Sunday 24 April 2011 08:29 PM, Johannes Berg wrote:
> > iw wlan0 station dump | grep ... | wc -l
> thanks, that  works! I need to divide by 11 :)

Heh, yes, but that might change and/or be HW dependent, hence grep. So
if you do

iw wlan0 station dump | grep '^Station ' | wc -l

you won't need to divide and won't be HW dependent.

johannes

