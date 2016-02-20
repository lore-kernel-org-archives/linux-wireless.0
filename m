Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1948676AbcBTBHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 20:07:13 -0500
Date: Fri, 19 Feb 2016 17:07:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Leo Kim <leo.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, Chris Park <chris.park@atmel.com>,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: move WILC_MULTICAST_TABLE_SIZE
 define to wilc_wlan_if.h file
Message-ID: <20160220010713.GB3109@kroah.com> (sfid-20160220_020718_472150_E956496D)
References: <1455875865-15505-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455875865-15505-1-git-send-email-leo.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2016 at 06:57:42PM +0900, Leo Kim wrote:
> From: Chris Park <chris.park@atmel.com>
> 
> This patch moves WILC_MULTICAST_TABLE_SIZE define to wilc_wlan_if.h file.
> This define is used to three files(host_interface.c,host_interface.h,
> linux_wlan.c) these files already include wilc_wlan_if.h file in common.
> 
> Signed-off-by: Chris Park <chris.park@atmel.com>
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/linux_wlan_common.h | 2 --
>  drivers/staging/wilc1000/wilc_wlan_if.h      | 2 +-
>  2 files changed, 1 insertion(+), 3 deletions(-)

Series doesn't apply :(

