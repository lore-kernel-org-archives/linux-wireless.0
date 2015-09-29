Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbbI2BVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 21:21:20 -0400
Date: Tue, 29 Sep 2015 02:39:36 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 5/6] staging: wilc1000: remove wilc_platform include file
Message-ID: <20150929003936.GA27938@kroah.com> (sfid-20150929_032123_306398_451FF514)
References: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com>
 <1442999030-31934-5-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442999030-31934-5-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2015 at 06:03:49PM +0900, Chaehyun Lim wrote:
> This patch removes wilc_platform.h include file in wilc_oswrapper.h
> Because wilc_platform.h have several standard header files so that some
> header file should be included .c file to avoid compilation errors.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 1 +
>  drivers/staging/wilc1000/host_interface.c   | 4 ++++
>  drivers/staging/wilc1000/wilc_oswrapper.h   | 2 --
>  drivers/staging/wilc1000/wilc_wlan_if.h     | 2 +-
>  4 files changed, 6 insertions(+), 3 deletions(-)

This patch, and 6/6 doesn't apply to the tree anymore, can you rebase
and resend them?

thanks,

greg k-h
