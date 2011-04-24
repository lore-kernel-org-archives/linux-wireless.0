Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab1DXO7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 10:59:16 -0400
Subject: Re: [PATCH] mac80211: Add num_stations connected in debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"L.Kriara@sms.ed.ac.uk" <L.Kriara@sms.ed.ac.uk>
In-Reply-To: <4DB4318F.6070801@atheros.com>
References: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com>
	 <1303652185.3603.0.camel@jlt3.sipsolutions.net>
	 <4DB4318F.6070801@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 16:59:10 +0200
Message-ID: <1303657150.3603.1.camel@jlt3.sipsolutions.net> (sfid-20110424_165919_117059_DAA7FD63)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-24 at 19:49 +0530, Mohammed Shafi wrote:
> On Sunday 24 April 2011 07:06 PM, Johannes Berg wrote:
> > On Sun, 2011-04-24 at 17:25 +0530, Mohammed Shafi Shajakhan wrote:
> >    
> >> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> >>
> >> this will be useful when the device is operating in AP/Ad-Hoc/Mesh
> >> mode
> >>      
> > Fine with me, but this counts for all virtual interfaces.
> >    
> thanks, I  had not thought about that. let me also if we can separately 
> have the number of stations connected to each virtual interfaces.

Probably not worth it? You can always get it with iw easily anyway, no?
Just do something like "iw wlan0 station dump | grep ... | wc -l"? :-)

johannes

