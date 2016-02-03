Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbcBCXJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:09:07 -0500
Date: Wed, 3 Feb 2016 15:09:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ivan Safonov <insafonov@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: wilc1000: wilc_parse_network_info
 refactoring
Message-ID: <20160203230907.GA15732@kroah.com> (sfid-20160204_001014_983058_BA314154)
References: <20151227165957.GA22276@alpha.sfu-kras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151227165957.GA22276@alpha.sfu-kras.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 27, 2015 at 11:59:57PM +0700, Ivan Safonov wrote:
> 1) Return value of this function does not used;
> 2) wilc_parse_network_info has no reasons to return an error;
> 3) kfree does not free memory if argument is NULL.
> 
> Signed-off-by: Ivan Safonov <insafonov@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 27 +++++----------------------
>  drivers/staging/wilc1000/coreconfigurator.h |  2 +-
>  2 files changed, 6 insertions(+), 23 deletions(-)

You sent 3 different copies of this same patch, so I don't know which to
apply :(

Please fix up and resend the series properly...

thanks,

greg k-h
