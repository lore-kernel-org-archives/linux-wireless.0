Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbbI2BUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 21:20:19 -0400
Date: Tue, 29 Sep 2015 02:34:38 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 3/4] staging: wilc1000: remove define
 WILC_PARSE_SCAN_IN_HOST
Message-ID: <20150929003438.GA20051@kroah.com> (sfid-20150929_032029_546281_A00E4F17)
References: <1442992255-23005-1-git-send-email-glen.lee@atmel.com>
 <1442992255-23005-3-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442992255-23005-3-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2015 at 04:10:54PM +0900, Glen Lee wrote:
> The define WILC_PARSE_SCAN_IN_HOST is always used in the driver, so just
> delete ifdef WILC_PARSE_SCAN_IN_HOST line, ifndef WILC_PARSE_SCAN_IN_HOST
> line and it's related codes. Finally, remove define in Makefile.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/Makefile         |  1 -
>  drivers/staging/wilc1000/host_interface.c | 62 -------------------------------
>  drivers/staging/wilc1000/wilc_wlan_if.h   |  3 +-
>  3 files changed, 1 insertion(+), 65 deletions(-)

This and the 4/4 patch does not apply to my tree, please rebase and
resend.

thanks,

greg kh
