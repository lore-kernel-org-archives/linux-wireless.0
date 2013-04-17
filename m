Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58063 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966341Ab3DQOb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 10:31:56 -0400
Message-ID: <516EB259.3010804@openwrt.org> (sfid-20130417_163200_184664_5F74D917)
Date: Wed, 17 Apr 2013 16:31:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: optimize minstrel_ewma
References: <1366199002-10177-1-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1366199002-10177-1-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-17 1:43 PM, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Use powers of two in ewma of minstrel.
> This changes :
> - EWMA_DIV   from 100 to 2^7
> - EWMA_LEVEL from 75 (/EWMA_DIV=100) to 2^6 + 2^5 (/EWMA_DIV=128)
> 
> Note that this changes EWMA_DIV - EWMA_LEVEL from 25 to 2^5 and keeps
> EWMA_LEVEL / EWMA_DIV == 0.75.
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>

