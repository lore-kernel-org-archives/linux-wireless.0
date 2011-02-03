Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab1BCLaa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 06:30:30 -0500
Date: Thu, 3 Feb 2011 12:28:14 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry.Finger@lwfinger.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	george0505 <george0505@realtek.com>,
	"'Zhaoming_Li'" <chaoming_li@realsil.com.cn>
Subject: Re: [RFC/RFT 3/8] rtl8192cu: Add new driver code - Part 2
Message-ID: <20110203112813.GD3516@redhat.com>
References: <1296411100-5675-1-git-send-email-Larry.Finger@lwfinger.net>
 <1296411100-5675-4-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296411100-5675-4-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 30, 2011 at 12:11:35PM -0600, Larry.Finger@lwfinger.net wrote:
> From: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: george0505 <george0505@realtek.com>
> Cc: 'Zhaoming_Li' <chaoming_li@realsil.com.cn>
> ---
>  drivers/net/wireless/rtlwifi/rtl8192cu/fw.c  |  685 ++++++++++++++++
>  drivers/net/wireless/rtlwifi/rtl8192cu/fw.h  |   97 +++
>  drivers/net/wireless/rtlwifi/rtl8192cu/led.c |  143 ++++
>  drivers/net/wireless/rtlwifi/rtl8192cu/led.h |   38 +
This files duplicate with rtl8192ce, that need to be merged
into one lib.

I'm not reading furhter, I will continue when you post
patches without code duplication.

Stanislaw
