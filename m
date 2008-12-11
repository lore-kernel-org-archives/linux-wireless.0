Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23103.mail.ird.yahoo.com ([217.146.189.43]:30591 "HELO
	web23103.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756584AbYLKRdU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 12:33:20 -0500
Date: Thu, 11 Dec 2008 17:33:18 +0000 (GMT)
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
Message-ID: <103016.83139.qm@web23103.mail.ird.yahoo.com> (sfid-20081211_183324_879688_04C9F85C)
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

okay, I like my wlan* device not to disappear. One way or the other, this needs fixing ASAP. It was very weird to put the latest wireless-testing on and wlanX is nowhere to be found :-). I'll dig through the archive for the patch. (still not subscribe to linux-wireless - maybe I should when I figure out gmail's filtering system).

Hin-Tak


      
