Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760269Ab3DJNKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 09:10:10 -0400
Message-ID: <1365599399.8388.13.camel@jlt4.sipsolutions.net> (sfid-20130410_151014_956420_5BEA4300)
Subject: Re: [PATCH v2] mac80211: provide SSID for IBSS vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 10 Apr 2013 15:09:59 +0200
In-Reply-To: <1365592753-5404-1-git-send-email-marek.puzyniak@tieto.com>
References: <1365592753-5404-1-git-send-email-marek.puzyniak@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-10 at 13:19 +0200, Marek Puzyniak wrote:
> Some drivers need SSID in AP and IBSS mode. AP SSID is provided
> through BSS_CHANGED_SSID notification. There was no easy way
> to do the same for IBSS. In IBSS mode SSID is known but was
> not stored in BSS configuration. This patch provides functionality
> which stores IBSS ssid in BSS conf and expands BSS_CHANGED_SSID
> notification to cover also IBSS mode.

Applied, I also removed the memset here.

johannes

