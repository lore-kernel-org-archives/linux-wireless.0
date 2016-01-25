Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38576 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbcAYNPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 08:15:38 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>, <tony.cho@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: Re: [PATCH V2 00/26] use unified firmware and add ops in cfg
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
Date: Mon, 25 Jan 2016 15:15:31 +0200
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com> (Glen
	Lee's message of "Mon, 25 Jan 2016 16:35:04 +0900")
Message-ID: <87vb6hu7f0.fsf@purkki.adurom.net> (sfid-20160125_141541_227417_04995FD6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Glen Lee <glen.lee@atmel.com> writes:

> This patch series contains                                                      
> * support suspend and resume functionality                                      
> * use a unified firmware for all mode of operations(station, ap, p2p)           
> * support Station/AP concurrency                                                
> * increase link speed                                                           
> * add a cfg operation for adjusting the tx power                                
> * fix bug on p2p, WEP security and chaning virtual interface
>
> Changes in V2: details in each patch files.
>  - 0004-staging-wilc1000-add-sdio-resume-suspend.patch

It's good practise to also add "staging: wilc1000: " prefix to the cover
letter.

-- 
Kalle Valo
