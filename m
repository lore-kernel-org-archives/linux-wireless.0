Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53583 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbLPOUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:20:23 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2015-12-16
References: <0BA3FCBA62E2DC44AF3030971E174FB32E91F275@hasmsx107.ger.corp.intel.com>
Date: Wed, 16 Dec 2015 16:20:16 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E91F275@hasmsx107.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Wed, 16 Dec 2015 08:15:09 +0000")
Message-ID: <87a8pafpb3.fsf@kamboji.qca.qualcomm.com> (sfid-20151216_152026_667284_EC875269)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> This is a pull request with small fixes for 4.4. Note that due to the
> large number of files being renamed, you need to set merge.renameLimit
> to a big number to merge wl-drv into wl-drv-next but you probably
> noticed that already :)

Actually I don't normally merge wireless-drivers to
wireless-drivers-next, that happens "automatically" the way I follow
net-next. But I'll keep this in mind, thanks.

>       iwlwifi: separate firmware version for 7260 devices

Was this patch sent for public review? I can't seem to find it.

-- 
Kalle Valo
