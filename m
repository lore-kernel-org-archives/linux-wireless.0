Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59076 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaATDie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jan 2014 22:38:34 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21212.39163.788339.349498@gargle.gargle.HOWL> (sfid-20140120_043837_495847_EEB96CBE)
Date: Mon, 20 Jan 2014 09:03:15 +0530
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
In-Reply-To: <52D8DC0E.40207@neratec.com>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
	<1384665016-12022-5-git-send-email-sujith@msujith.org>
	<52CE934D.1020400@neratec.com>
	<21198.40916.260973.48444@gargle.gargle.HOWL>
	<52CEA5A3.2040308@neratec.com>
	<21198.43395.235654.597422@gargle.gargle.HOWL>
	<52CEAB24.5090700@neratec.com>
	<52D3F962.1010302@neratec.com>
	<21204.319.492595.58625@gargle.gargle.HOWL>
	<52D402C3.3070606@neratec.com>
	<21204.1991.201080.986559@gargle.gargle.HOWL>
	<21204.2384.710460.402183@gargle.gargle.HOWL>
	<21204.3832.404821.109119@gargle.gargle.HOWL>
	<52D63EBB.7020607@neratec.com>
	<21206.17284.157496.206327@gargle.gargle.HOWL>
	<52D6472B.2060207@neratec.com>
	<21207.48441.292580.481850@gargle.gargle.HOWL>
	<21207.49245.151249.759167@gargle.gargle.HOWL>
	<52D7C62F.2030307@neratec.com>
	<21208.20686.79159.966434@gargle.gargle.HOWL>
	<52D8DC0E.40207@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik wrote:
> I agree it's more of a workaround because there can be situations
> where measured value is far from calibrated. In my setup it
> helps but I haven't yet tested what happens in the noisy environment.
> 
> Do you know a better way to fix this? I am not so deep into calibration
> tasks but I have a working setup so I could spend more time on that.

Well, like I mentioned before, I am not sure if this needs to be fixed.
The calibration history is cleared only once on association, anyway.

If this happens when running background scans when associated, we can
try to fix it. But, I have not seen such behavior, so it would be good
to have logs that show abnormal rssi during scan.

Sujith
