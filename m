Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43652 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1JKUar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 16:30:47 -0400
Date: Tue, 11 Oct 2011 16:16:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH 4/5] rtlwifi: rtl8192se: Updates from latest Realtek
 driver version - Part II
Message-ID: <20111011201615.GK6558@tuxdriver.com> (sfid-20111011_223051_028024_FBDB7484)
References: <1318005802-29057-1-git-send-email-Larry.Finger@lwfinger.net>
 <1318005802-29057-5-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1318005802-29057-5-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 07, 2011 at 11:43:21AM -0500, Larry Finger wrote:
> From: Chaoming Li <chaoming_li@realsil.com.cn>
> 
> This patch incorporate the differences between the 06/20/2011 and
> 08/16/2011 Realtek releases of the rtl8192se driver.
> 
> The changes include:
> 
> 1. Fixing some typos in register usage.
> 2. A change in the handling of decryption status for 802.11w packets.
> 
> Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

This patch doesn't apply (at least on wireless-next), and several of
the others required fixups as well.  What tree did you base this upon?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
