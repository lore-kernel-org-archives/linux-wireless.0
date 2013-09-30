Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3I3Jch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 05:32:37 -0400
Message-ID: <1380533553.14467.6.camel@jlt4.sipsolutions.net> (sfid-20130930_113240_807285_1CA1E310)
Subject: Re: [PATCH] iw: sync frequency to channel mapping with kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Sep 2013 11:32:33 +0200
In-Reply-To: <1380213945-31815-1-git-send-email-br1@einfach.org>
References: <1380213945-31815-1-git-send-email-br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-09-26 at 17:45 +0100, Bruno Randolf wrote:
> Use ieee80211_frequency_to_channel() and ieee80211_channel_to_frequency() as in
> the current kernel. This is necessary to properly print the channel numbers for
> 4.9GHz channels which can be used in Japan.

Applied.

johannes

