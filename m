Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbcBCXco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:32:44 -0500
Date: Wed, 3 Feb 2016 15:32:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Leo Kim <leo.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, Chris Park <chris.park@atmel.com>,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 1/6] staging: wilc1000: fix warnings for line over 80
 characters
Message-ID: <20160203233243.GA14810@kroah.com> (sfid-20160204_003249_645010_4F68C197)
References: <1454050298-25815-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454050298-25815-1-git-send-email-leo.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 29, 2016 at 03:51:33PM +0900, Leo Kim wrote:
> From: Chris Park <chris.park@atmel.com>
> 
> This patch fixes warnings reported by checkpatch.pl
> for line over 80 characters
> 
> Signed-off-by: Chris Park <chris.park@atmel.com>
> Signed-off-by: Leo Kim <leo.kim@atmel.com>

This series didn't apply either, please fix up and resend.

thanks,

greg k-h
