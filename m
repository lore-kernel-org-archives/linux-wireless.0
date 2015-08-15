Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbHOCEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 22:04:10 -0400
Date: Fri, 14 Aug 2015 19:04:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, jude.lee@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 4/5] staging: wilc1000: use the real data type
Message-ID: <20150815020410.GA25681@kroah.com> (sfid-20150815_040414_135274_BFA45C99)
References: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
 <1439440883-16061-5-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439440883-16061-5-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2015 at 01:41:22PM +0900, Tony Cho wrote:
> From: Johnny Kim <johnny.kim@atmel.com>
> 
> This patch changes the type of gu8FlushedJoinReqDrvHandler with his real
> data type becasue typecasting is not necessary. In result, typecasting
> which is not necessary and some building warnings is removed.
> 
> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

This patch doesn't apply to my tree anymore due to patches from other
people touching the same area.  Please rebase it, and fix up the 5/5
patch, and resend both of them as a new series.

thanks,

greg k-h
