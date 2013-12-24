Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41695 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab3LXNft (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 08:35:49 -0500
Message-ID: <52B98DAB.2090701@openwrt.org> (sfid-20131224_143554_476567_D83F3FA4)
Date: Tue, 24 Dec 2013 14:35:39 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/11] ath9k: Fix "cc_lock" usage
References: <1387862067-25457-1-git-send-email-sujith@msujith.org>	<1387862067-25457-11-git-send-email-sujith@msujith.org>	<52B9715F.8000002@openwrt.org> <21177.35573.334187.908805@gargle.gargle.HOWL>
In-Reply-To: <21177.35573.334187.908805@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-24 14:24, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> I think you forgot to remove the now unused 'flags' variable in a few
>> places.
> 
> Which ones ? -Wunused-variable is enabled and gcc doesn't show any warnings...
Sorry, never mind. Something went wrong in my tree and the patch wasn't
applied properly.

- Felix

