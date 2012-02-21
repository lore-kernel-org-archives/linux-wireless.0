Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11254 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab2BUOPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 09:15:39 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20291.42747.83289.428844@gargle.gargle.HOWL> (sfid-20120221_151542_333474_829DA1CB)
Date: Tue, 21 Feb 2012 19:45:23 +0530
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC/WIP 14/22] ath9k_hw: Cleanup MCI bits from hw.h
In-Reply-To: <CAD2nsn2tcp5+j5QYC6kJF+VReCWSHpxnjLBk4OOdV75DaBVuSQ@mail.gmail.com>
References: <20291.25228.754516.300644@gargle.gargle.HOWL>
	<CAD2nsn2tcp5+j5QYC6kJF+VReCWSHpxnjLBk4OOdV75DaBVuSQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi wrote:
> we did put all those stuff in ar9003_mci.h, but then it caused lot of
> compilation errors.
> we fixed it overnight. would including ar9003_mci.h in mci.h won't be
> a problem. i thought mci.h is part of ath9k(non-hw related stuff).
> please let me know if i had missed something.

Well, having an abstraction layer (ath9k_hw_*) for only one family is
overkill, so I think it is fine.

Sujith
