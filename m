Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBXMVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 07:21:19 -0500
Message-ID: <1393244470.4190.6.camel@jlt4.sipsolutions.net> (sfid-20140224_132122_210980_5AFEFF84)
Subject: Re: [PATCH v1 1/6] mac80211: move flag IEEE80211_TX_CTL_ASSIGN_SEQ
 into info->control.flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name
Date: Mon, 24 Feb 2014 13:21:10 +0100
In-Reply-To: <1393164527-13800-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1393164527-13800-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-02-23 at 15:08 +0100, Thomas Huehn wrote:

>  enum mac80211_tx_info_flags {
>  	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
> -	IEEE80211_TX_CTL_ASSIGN_SEQ		= BIT(1),
> -	IEEE80211_TX_CTL_NO_ACK			= BIT(2),

I'd prefer you didn't renumber all of them in every single patch ...
maybe in the last one if you need it for some reason, or better
separately I guess.

johannes

