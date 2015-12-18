Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbbLSAoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:44:21 -0500
Date: Fri, 18 Dec 2015 14:37:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 3/6] staging: wilc1000: wilc_wlan.c: remove hif_func of
 wilc_wlan_dev_t
Message-ID: <20151218223714.GA27454@kroah.com> (sfid-20151219_014424_843405_3FBD0402)
References: <1448006196-28555-1-git-send-email-glen.lee@atmel.com>
 <1448006196-28555-3-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448006196-28555-3-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 20, 2015 at 04:56:33PM +0900, Glen Lee wrote:
> hif_func of wilc_wlan_dev_t is duplicate because we have same struct
> wilc_hif_func ops of struct wilc which is available in wilc_wlan.c.
> Rename ops of struct wilc with hif_func and remove hif_func of wilc_wlan_dev_t,
> and use wilc->hif_func instead of g_wlan.hif_func in all functions.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c         |  18 +--
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h |   2 +-
>  drivers/staging/wilc1000/wilc_wlan.c          | 161 ++++++++++++--------------
>  3 files changed, 87 insertions(+), 94 deletions(-)

This patch didn't apply, so I stopped here in the series, please fix up
and resend.

thanks,

greg k-h
