Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2FIIJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:09:54 -0400
Message-ID: <1339229392.4539.8.camel@jlt3.sipsolutions.net> (sfid-20120609_101000_309925_65838C55)
Subject: Re: [RFC 2/2] mac80211: support rssi threshold scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Date: Sat, 09 Jun 2012 10:09:52 +0200
In-Reply-To: <1339036996-6199-2-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 <1339036996-6199-2-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 19:43 -0700, Thomas Pedersen wrote:

> +	if (sdata->local->scan_req->rssi &&
> +	    rx_status->signal < sdata->local->scan_req->rssi)
> +		return RX_DROP_MONITOR;

I believe that should be RX_CONTINUE

johannes

