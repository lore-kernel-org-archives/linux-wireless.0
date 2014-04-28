Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40563 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274AbaD1QMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 12:12:49 -0400
Message-ID: <1398701560.4132.6.camel@jlt4.sipsolutions.net> (sfid-20140428_181304_773627_75BE6E51)
Subject: Re: [PATCH 1/3] cfg80211: Dynamic channel bandwidth changes in AP
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 28 Apr 2014 18:12:40 +0200
In-Reply-To: <20140428082208.GA15442@jouni.qca.qualcomm.com>
References: <20140428082208.GA15442@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-28 at 11:22 +0300, Jouni Malinen wrote:
> This extends NL80211_CMD_SET_CHANNEL to allow dynamic channel bandwidth
> changes in AP mode (including P2P GO) during a lifetime of the BSS. This
> can be used to implement, e.g., HT 20/40 MHz co-existence rules on the
> 2.4 GHz band.

Applied all three, but I renamed the internal function to
set_ap_chanwidth.

johannes

