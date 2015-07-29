Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbG2UpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 16:45:13 -0400
Date: Wed, 29 Jul 2015 13:45:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH V2 1/3] staging: wilc1000: coreconfigurator.c: remove
 WILC_MALLOC
Message-ID: <20150729204507.GA9379@kroah.com> (sfid-20150729_224518_057745_19285810)
References: <1437695755-9731-1-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437695755-9731-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 24, 2015 at 08:55:53AM +0900, Chaehyun Lim wrote:
> Use kmalloc and kmalloc_array instead of WILC_MALLOC.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
> V2: Use GFP_KERNEL flag instead of GFP_ATOMIC

Please answer Dan's question for the next time you resend this series, I
can't take these as-is so am dropping them from my queue.

greg k-h
