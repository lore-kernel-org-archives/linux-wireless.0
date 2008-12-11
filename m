Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23102.mail.ird.yahoo.com ([217.146.189.42]:22380 "HELO
	web23102.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758534AbYLKTYY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 14:24:24 -0500
Date: Thu, 11 Dec 2008 19:24:22 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Fix for change in STA handling in mac80211
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <494132C3.5070907@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <433348.77904.qm@web23102.mail.ird.yahoo.com> (sfid-20081211_202429_737233_F467FCDB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 11/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Hin-Tak Leung wrote:
> > 
> > I don't know the verdict yet - but I think we need
> to either revert Johannes's earlier patch, or have this
> change from Larry incoporated, ASAP.
> > 
> > Hin-Tak
> 
> No, the best solution is to incorporate Johannes patch of
> today. Now that I
> understand what happened, my patch just wallpapers over his
> mistake.
> 
> To explain how that happened, he used
> NL80211_IFTYPE_STATION (2) when he meant
> BIT(NL80211_IFTYPE_STATION)(4). My "fix" works
> because BIT(NL80211_IFTYPE_ADHOC)
> == NL80211_IFTYPE_STATION.

Found Johannes's new patch - and using it right now. So I could have a 
Tested-by: ... Yes, it makes more sense :-).

Hin-Tak




      
