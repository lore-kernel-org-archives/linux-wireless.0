Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2FNGs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 02:48:58 -0400
Message-ID: <1339656532.4909.0.camel@jlt3.sipsolutions.net> (sfid-20120614_084901_667565_4C84A9DF)
Subject: Re: [PATCH] nl80211: specify RSSI threshold when scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
Cc: Holger Schurig <holgerschurig@googlemail.com>,
	kvalo@qca.qualcomm.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Thu, 14 Jun 2012 08:48:52 +0200
In-Reply-To: <20120613204537.GA3043@pista>
References: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 <1339566003.4519.1.camel@jlt3.sipsolutions.net>
	 <CAOpc7mEZ3Wd2JajqTpj+tZXVyE_QC1=xS3gXF9eFjmCdTu8Xug@mail.gmail.com>
	 <20120613204537.GA3043@pista>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-13 at 13:45 -0700, Pedersen, Thomas wrote:
> On Wed, Jun 13, 2012 at 07:53:51AM +0200, Holger Schurig wrote:
> > @NL80211_ATTR_SCHED_SCAN_MATCH_RSSI
> > 
> > I'd also move around "SCHED" and "ATTR". Look at the attribute names
> > above or below it, then it's more obvious:
> > 
> > NL80211_SCHED_SCAN_MATCH_ATTR_SSID
> > NL80211_ATTR_SCHED_SCAN_MATCH_RSSI
> > NL80211_SCHED_SCAN_MATCH_ATTR_MAX
> 
> Makes sense. In wireless-testing HEAD the SSID match attr is actually
> "NL80211_ATTR_SCHED_SCAN_MATCH_SSID".

I just fixed that :)

johannes

