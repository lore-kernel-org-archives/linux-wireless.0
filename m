Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab0K3LYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 06:24:06 -0500
Subject: Re: [PATCH] nl80211: add NL80211_ATTR_PS_TIMEOUT attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291111467-10531-1-git-send-email-eliad@wizery.com>
References: <1291111467-10531-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 12:24:04 +0100
Message-ID: <1291116244.3624.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-30 at 12:04 +0200, Eliad Peller wrote:
> with this attribute we can control the timeout in dynamic ps
> (similar to "iwconfig wlan0 power timeout" command).

I don't really like this -- what's the point? What user is going to have
a good idea of how to set this? We are currently setting this depending
on the QoS requirements in mac80211, I believe, which seems smarter.

johannes

