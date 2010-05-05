Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48134 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab0EELq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 07:46:58 -0400
Subject: Re: [PATCH] mac80211: Add HT IE to IBSS beacons and probe
 responses.
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1272955622-6987-3-git-send-email-benoit.papillault@free.fr>
References: <1272955622-6987-1-git-send-email-benoit.papillault@free.fr>
	 <1272955622-6987-2-git-send-email-benoit.papillault@free.fr>
	 <1272955622-6987-3-git-send-email-benoit.papillault@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 13:46:54 +0200
Message-ID: <1273060014.3728.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-04 at 08:47 +0200, Benoit Papillault wrote:
> When an HT IBSS is configured, we add HT Information and HT Capabilities
> IE to beacon & probe responses. This is done according to channel_type
> transmitted by iw/cfg80211.

Just noticed something else -- this allows creating an HT40 IBSS on an
invalid channel pair -- do we want to catch that?

johannse

