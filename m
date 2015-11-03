Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbKCPGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 10:06:48 -0500
Date: Tue, 3 Nov 2015 07:06:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH] Revert "Staging: wilc1000: coreconfigurator: Drop
 unneeded wrapper functions"
Message-ID: <20151103150643.GB26934@kroah.com> (sfid-20151103_160651_390228_A9E25B4A)
References: <1446545111-23325-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446545111-23325-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 03, 2015 at 07:05:11PM +0900, Glen Lee wrote:
> The addresses are not properly aglined for using ether_addr_copy function.
> I revert this as author agree to drop this patch.
> 
> This reverts commit d4622f68db8095dd54179e3134e97812727f6b89.
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 48 +++++++++++++++--------------
>  1 file changed, 25 insertions(+), 23 deletions(-)

No signed-off-by: line :(


