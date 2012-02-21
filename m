Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10366 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2BUOSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 09:18:35 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20291.42915.691523.481193@gargle.gargle.HOWL> (sfid-20120221_151838_808128_01DA9CBA)
Date: Tue, 21 Feb 2012 19:48:11 +0530
To: Julian Calaby <julian.calaby@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC/WIP 16/22] ath9k_hw: Use CONFIG_ATH9K_BTCOEX_SUPPORT
In-Reply-To: <CAGRGNgVNRR=KRXrjYFSisQisd97gGPOxy4GE0iRipk7ZCLDQOA@mail.gmail.com>
References: <20291.25241.5396.839366@gargle.gargle.HOWL>
	<CAGRGNgVNRR=KRXrjYFSisQisd97gGPOxy4GE0iRipk7ZCLDQOA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby wrote:
> If I recall correctly, the recommended form here is to create a inline
> function that returns false, rather than the #define - this way the
> type checking of the function's arguments still happens when
> CONFIG_ATH9K_BTCOEX_SUPPORT is disabled.

Right, that would be more elegant.

> You've done this a couple of other times in this patch too.

I'll fix them in the next iteration, thanks for the review.

Sujith
