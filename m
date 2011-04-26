Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1DZMHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 08:07:13 -0400
Subject: Re: [PATCH] mac80211: Add num_stations connected in debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: Lito Kriara <L.Kriara@sms.ed.ac.uk>,
	Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4DB6B48D.6080508@atheros.com>
References: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com>
	 <1303652185.3603.0.camel@jlt3.sipsolutions.net>
	 <4DB4318F.6070801@atheros.com>
	 <1303657150.3603.1.camel@jlt3.sipsolutions.net>
	 <4DB4415F.2070707@atheros.com>
	 <1303659120.3603.3.camel@jlt3.sipsolutions.net>
	 <4DB4F8D5.1060108@atheros.com>
	 <20110426125801.q89ma5n6cgkwog80@www.sms.ed.ac.uk>
	 <4DB6B48D.6080508@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 14:07:02 +0200
Message-ID: <1303819622.4784.3.camel@jlt3.sipsolutions.net> (sfid-20110426_140717_077051_C12B719A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-26 at 17:33 +0530, Mohammed Shafi wrote:
> On Tuesday 26 April 2011 05:28 PM, Lito Kriara wrote:
> > Hello,
> > I was away the last couple of days and just saw these e-mails. It
> > seems really interesting and helpful, but what if we need to know at
> > runtime the number of stations connected to the AP?
> > Is the first patch sent good to use? Should I do some modification to it?
> >    
> Yes this will be fine.

Or you can use what I wrote without patching:

> >>> iw wlan0 station dump | grep '^Station ' | wc -l

FWIW, I wouldn't mind adding the num_sta to debugfs, but as we discussed
in this thread it's a different number.

johannes

