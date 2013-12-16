Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49659 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab3LPNvN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 08:51:13 -0500
Message-ID: <52AF0547.1060505@openwrt.org> (sfid-20131216_145129_387099_D3F855B4)
Date: Mon, 16 Dec 2013 14:51:03 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 06/11] ath9k_hw: remove ah->config.pcie_clock_req
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>	<1387040625-38114-6-git-send-email-nbd@openwrt.org>	<21166.30518.304613.545323@gargle.gargle.HOWL>	<52AEE12F.5020008@openwrt.org> <21166.64423.30022.947286@gargle.gargle.HOWL>
In-Reply-To: <21166.64423.30022.947286@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-16 14:09, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> Fine with me, let's leave this one out and merge the others (if there
>> aren't any other issues).
> 
> Station mode seems fine with the series, I didn't get a chance to test
> IBSS or P2P.
> 
> In AP mode, the timestamp in the first beacon is higher than earlier, since
> we no longer reset the HW TSF when enabling beaconing and there is a
> window between start() and enable_beacon(). I am not sure if this is a
> problem, but I think the spec has something to say about BSS creation in
> infrastructure mode.
I looked through the spec and could not find any indication that
starting at zero is mandatory.

- Felix
