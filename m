Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab2AaFrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 00:47:39 -0500
Message-ID: <4F278050.8030407@sipsolutions.net> (sfid-20120131_064741_964249_248F5B51)
Date: Mon, 30 Jan 2012 21:46:56 -0800
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Victor Goldenshtein <victorg@ti.com>
CC: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Subject: Re: [RFC 5/9] nl80211/cfg80211: add ap channel switch command/event
References: <1327581484-22047-1-git-send-email-victorg@ti.com> <1327581484-22047-6-git-send-email-victorg@ti.com>
In-Reply-To: <1327581484-22047-6-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/26/2012 4:38 AM, Victor Goldenshtein wrote:
> Add new NL80211_CMD_AP_CHANNEL_SWITCH command which
> triggers a channel switch process, this command also
> notifies usermode about channel switch complete event.

I think this needs a little more explaining how it would be used with 
hostapd adding the channel switch IEs into the beacon.

johannes
