Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:28443 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZGYJUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 05:20:35 -0400
Received: by fg-out-1718.google.com with SMTP id e21so567522fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 02:20:33 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix oops in ieee80211_scan_state_set_channel()
Date: Sat, 25 Jul 2009 11:20:40 +0200
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20090725051801.2965.76768.stgit@ct.roinet.com> <1248512095.32151.50.camel@johannes.local>
In-Reply-To: <1248512095.32151.50.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907251120.41188.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 25. Juli 2009 schrieb Johannes Berg:
> On Sat, 2009-07-25 at 01:18 -0400, Pavel Roskin wrote:
> > Move check for the final value of local->scan_channel_idx from
> > ieee80211_scan_state_decision() to ieee80211_scan_state_set_channel().
> > 
> > Stop the state machine in ieee80211_scan_work() by checking
> > local->scanning.  Don't return a value from
> > ieee80211_scan_state_decision().
> 
> Helmut, can you please take a look at this? I'm not entirely sure what's
> going on.

That's strange. I cannot reproduce the oops here :(

Investigating ...

Thanks,
Helmut
