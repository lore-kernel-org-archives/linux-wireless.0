Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37367 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab2KEOzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 09:55:50 -0500
Message-ID: <1352127385.9466.16.camel@jlt4.sipsolutions.net> (sfid-20121105_155603_813516_8321EC26)
Subject: Re: [PATCHv5 1/2] nl/cfg80211: add the NL80211_CMD_SET_MCAST_RATE
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 05 Nov 2012 15:56:25 +0100
In-Reply-To: <1351859269-27134-1-git-send-email-ordex@autistici.org>
References: <1351859269-27134-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-02 at 13:27 +0100, Antonio Quartulli wrote:
> This command triggers a new callback: set_mcast_rate(). It enables
> the user to change the rate used to send multicast frames for vif
> configured as IBSS or MESH_POINT
> 

Applied.

> v4:

>  - advertise command in nl80211_send_wiphy()

I added that back to v5 :)

johannes

