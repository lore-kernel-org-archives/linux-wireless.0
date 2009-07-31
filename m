Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60648 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZGaTE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 15:04:27 -0400
Message-ID: <4A733FFD.60407@candelatech.com>
Date: Fri, 31 Jul 2009 12:03:25 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	mcgrof@gmail.com, nbd@openwrt.org
Subject: Re: [ath5k-devel] [PATCH 3/4] ath5k: Wakeup fixes
References: <20090731180805.GD7963@makis>
In-Reply-To: <20090731180805.GD7963@makis>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2009 11:08 AM, Nick Kossifidis wrote:
>   * Don't put chip to full sleep because there are problems during
>     wakeup. Instead hold MAC/Baseband on warm reset state via a new
>     function ath5k_hw_on_hold.
>
>   * Durring attach preserve pcicfg bits when enabling pci core
>     sw retry fix.
>
>   * Minor cleanups

I patched just this patch (not your other 3) into 2.6.31-rc4 and it seems
to fix the wakeup problems I was seeing on module unload/load.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

