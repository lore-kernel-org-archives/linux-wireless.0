Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab0I0PJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 11:09:15 -0400
Subject: Re: active vs. passive scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext Chuck Crisler <ccrisler@vgocom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285599964.5768.120.camel@chilepepper>
References: <15713CDD627C41D39E4B9725AE2B241D@ChuckPC>
	 <1285599964.5768.120.camel@chilepepper>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 17:09:11 +0200
Message-ID: <1285600151.4043.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 18:06 +0300, Luciano Coelho wrote:

> Usually the drivers stay for a certain period of time in each channel,
> and that normally doesn't change if you have active or passive scan.  So
> there will be no improvement in the overall scan speed.  Of course you
> could do some tweaks that might improve scanning performance in specific
> cases.

It's certainly different with mac80211:

#define IEEE80211_CHANNEL_TIME (HZ / 33)
#define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 8)

johannes

