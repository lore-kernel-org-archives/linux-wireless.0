Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbbLSAo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:44:27 -0500
Date: Fri, 18 Dec 2015 14:42:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: linux_wlan_spi.c: return linux
 error value
Message-ID: <20151218224232.GA8863@kroah.com> (sfid-20151219_014430_029165_7200A684)
References: <1448444129-11045-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448444129-11045-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 25, 2015 at 06:35:26PM +0900, Glen Lee wrote:
> return linux error value instead of 0 or 1 and use -EINVAL. Related codes
> also changed together.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/linux_wlan_spi.c | 14 +++-----------
>  drivers/staging/wilc1000/wilc_spi.c       | 18 +++++++++---------
>  2 files changed, 12 insertions(+), 20 deletions(-)

Series did not apply :(
