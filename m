Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610AbcBCXfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:35:13 -0500
Date: Wed, 3 Feb 2016 15:35:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Leo Kim <leo.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, Chris.Park@atmel.com,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 01/26] staging: wilc1000: removes function
 'wilc_dealloc_network_info()'
Message-ID: <20160203233512.GA29506@kroah.com> (sfid-20160204_003522_437739_FF4BC08D)
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 02, 2016 at 09:02:11PM +0900, Leo Kim wrote:
> This patch removes function 'wilc_dealloc_network_info()'.
> Does not need this function which only free memory.
> Therefore, this function is removed and changed directly with kfree.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>

This series didn't apply either :(
