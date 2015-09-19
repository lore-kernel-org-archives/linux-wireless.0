Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbbISE7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 00:59:24 -0400
Date: Fri, 18 Sep 2015 19:52:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH v2 2/4] staging: wilc1000: remove warnings on the
 multiple blank lines uses
Message-ID: <20150919025212.GA3614@kroah.com> (sfid-20150919_065930_579325_7E1C495E)
References: <1442484140-13485-1-git-send-email-tony.cho@atmel.com>
 <1442484140-13485-3-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442484140-13485-3-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 17, 2015 at 07:02:18PM +0900, Tony Cho wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch removes the warnings reported by checkpatch.pl
> for using multiple blank lines.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan_if.h | 12 ------------
>  1 file changed, 12 deletions(-)

Does not apply :(

Neither did patches 3 and 4 in this series, please rebase and resend.

thanks,

greg k-h
