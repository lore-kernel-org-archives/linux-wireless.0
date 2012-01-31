Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44505 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2AaFoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 00:44:17 -0500
Message-ID: <4F277F85.1090901@sipsolutions.net> (sfid-20120131_064420_942073_C26F10E6)
Date: Mon, 30 Jan 2012 21:43:33 -0800
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Victor Goldenshtein <victorg@ti.com>
CC: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Subject: Re: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on op-channel
References: <1327581484-22047-1-git-send-email-victorg@ti.com> <1327581484-22047-4-git-send-email-victorg@ti.com>
In-Reply-To: <1327581484-22047-4-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/26/2012 4:37 AM, Victor Goldenshtein wrote:
> The dfs master device should monitor radar channels
> for potential radar interference for a minimum of
> CAC (channel availability check) time, during this
> period no tx can occur. If no radar interference
> is detected the dfs master may initiate the tx with
> new NL80211_CMD_DFS_ENABLE_TX command.

So do we think that no safeguards here at all are acceptable? Not even 
checking that radar detection was enabled, CAC time expired, etc.?

johannes
