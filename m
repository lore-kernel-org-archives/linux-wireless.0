Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:37906 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbcCMTE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Mar 2016 15:04:57 -0400
Date: Sun, 13 Mar 2016 15:04:54 -0400 (EDT)
Message-Id: <20160313.150454.1285398123514574559.davem@davemloft.net> (sfid-20160313_200510_017454_DD012F07)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2016-03-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <87vb4vpga7.fsf@kamboji.qca.qualcomm.com>
References: <87vb4vpga7.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Wed, 09 Mar 2016 22:06:40 +0200

> here's a pull request for 4.6. I'm planning to send one more but I'm not
> sure if it will make it in time, we'll see.
> 
> Here notable changes are refactoring in bcma to create a common flash
> driver, brcmfmac platform data improvements in include/linux and
> beginning of AHB bus support for ath10k along with device tree binding
> update. More info in the signed tag below.
> 
> Oh, and I just noticed that weirdly my name appeared in author field on
> one of Janusz' ath9k patches. But I didn't consider this bad enough to
> rebase everything so I let it be. Sorry Janusz :)
> 
> commit b9a9693fd9aea43f50b107dfc8cbaea317f95a79
> Author: Kalle Valo <Janusz.Dziedzic@tieto.com>
> Date:   Fri Nov 27 09:37:14 2015 +0100
> 
>     ath9k: request NOA update when chanctx active
> 
> Please let me know if you have any problems.

Yeah it's always an unfortunate tradeoff when something in the commit
history of a tree everyone clones and works against turns out to be
incorrect :-/

Pulled, thanks.
