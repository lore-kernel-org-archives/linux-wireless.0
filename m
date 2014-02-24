Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaBXM05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 07:26:57 -0500
Message-ID: <1393244813.4190.11.camel@jlt4.sipsolutions.net> (sfid-20140224_132659_807196_FE9F1367)
Subject: Re: [PATCH v1 5/6] mac80211: move flag IEEE80211_TX_CTL_TX_OFFCHAN
 into info->control.flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name
Date: Mon, 24 Feb 2014 13:26:53 +0100
In-Reply-To: <1393164527-13800-6-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1393164527-13800-6-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-02-23 at 15:08 +0100, Thomas Huehn wrote:
> Flag IEEE80211_TX_CTL_TX_OFFCHAN is only used within the tx path while
> ieee80211_tx_info->control is valid. Therefore this patch moves this flag
> from info->flags structure into the info->control.flags and renames it to
> IEEE80211_TX_CTRL_TX_OFFCHAN.

Same problem as patch 1.

johannes

