Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965372AbbKDUw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 15:52:59 -0500
Date: Wed, 4 Nov 2015 12:52:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	tony.cho@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 1/5] staging: wilc1000: change enum variable name with
 lower case
Message-ID: <20151104205258.GA30460@kroah.com> (sfid-20151104_215302_039923_0E32BAFF)
References: <1446535262-19817-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446535262-19817-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 03, 2015 at 04:20:58PM +0900, Glen Lee wrote:
> This patch changes WID_TYPE with wid_type which is preferred style.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.h | 2 +-
>  drivers/staging/wilc1000/wilc_wlan_if.h     | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Some of these patches applied, some did not, please refresh and resend
the ones I didn't take.

thanks,

greg k-h
