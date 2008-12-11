Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23101.mail.ird.yahoo.com ([217.146.189.41]:30609 "HELO
	web23101.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755942AbYLKL61 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 06:58:27 -0500
Date: Thu, 11 Dec 2008 11:58:25 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Fix for change in STA handling in mac80211
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1228984004.15837.77.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <99722.20602.qm@web23101.mail.ird.yahoo.com> (sfid-20081211_125843_303010_AE616F26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 11/12/08, Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes@sipsolutions.net>
> Subject: Re: [PATCH] rtl8187: Fix for change in STA handling in mac80211
> To: "Larry Finger" <Larry.Finger@lwfinger.net>
> Cc: "John W Linville" <linville@tuxdriver.com>, "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>, "Hin-Tak Leung" <htl10@users.sourceforge.net>, linux-wireless@vger.kernel.org
> Date: Thursday, 11 December, 2008, 8:26 AM
> On Wed, 2008-12-10 at 19:59 -0600, Larry Finger wrote:
> > After commit ca247d5f50acd4fc6fdc1dec770e726b0d7eda60
> "mac80211: only create
> > default STA interface if supported", rtl8187
> stopped working because the
> > add_interface callback was not called. For reasons
> that I do not understand,
> > the IFTYPE_ADHOC bit, as well as the IFTYPE_STATION
> bit, must be set in the
> > interface_modes variable.
> 
> Because I'm stupid. Don't apply this patch.

okay - that explains why my wlan* device disappeared last night after upgrading to the latest wireless-testing :-). I knew breakage like that got to be big news in the wireless-testing mailing list, *if only and as soon as I can revert the change to get my wireless connectivity back*.

I better go and check Larry's patch and see how it turns out :-). Write again soon, after I have tested Larry's patch, hopefully.

Hin-Tak




      
