Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3BMWmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 17:42:20 -0500
Message-ID: <1360795332.8868.29.camel@jlt4.sipsolutions.net> (sfid-20130213_234224_849740_4C3695B1)
Subject: Re: [PATCHv6 0/2] mac80211: fix VLAN support on AP with ps-sta
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 13 Feb 2013 23:42:12 +0100
In-Reply-To: <1360770556-6716-1-git-send-email-michael-dev@fami-braun.de> (sfid-20130213_164936_016905_0C22257E)
References: <1360770556-6716-1-git-send-email-michael-dev@fami-braun.de>
	 (sfid-20130213_164936_016905_0C22257E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 16:49 +0100, Michael Braun wrote:

> Michael Braun (2):
>   mac80211: free ps->bc_buf skbs on vlan device stop
>   mac80211: fix WPA with VLAN on AP side with ps-sta

Applied both, thanks.

johannes

