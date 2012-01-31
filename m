Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2AaFpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 00:45:51 -0500
Message-ID: <4F277FE3.8090006@sipsolutions.net> (sfid-20120131_064555_022926_F8F0D0F1)
Date: Mon, 30 Jan 2012 21:45:07 -0800
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Victor Goldenshtein <victorg@ti.com>
CC: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Subject: Re: [RFC 4/9] mac80211: add ability to enable TX on op-channel
References: <1327581484-22047-1-git-send-email-victorg@ti.com> <1327581484-22047-5-git-send-email-victorg@ti.com>
In-Reply-To: <1327581484-22047-5-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/26/2012 4:37 AM, Victor Goldenshtein wrote:
> Prior starting tx on DFS channels, the DFS master
> device shall perform a Channel Availability Check
> to ensure that there is no radar interference on
> those channels. Once CAC done, the tx can be
> enabled with ieee80211_dfs_en_tx().

How do you expect this to be used by the device? It seems that it should 
have the side effect of lifting some TX-prohibited flag instead?

johannes
