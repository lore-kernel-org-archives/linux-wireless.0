Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbbLSAod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:44:33 -0500
Date: Fri, 18 Dec 2015 14:48:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: devel@driverdev.osuosl.org, rdunlap@infradead.org,
	chris.park@atmel.com, austin.shin@atmel.com, johnny.kim@atmel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] staging: wilc1000: Fix typo in linux_wlan.c
Message-ID: <20151218224852.GA20926@kroah.com> (sfid-20151219_014438_342894_9FA5EED9)
References: <1448286080-14787-1-git-send-email-standby24x7@gmail.com>
 <1448286080-14787-3-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448286080-14787-3-git-send-email-standby24x7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2015 at 10:41:19PM +0900, Masanari Iida wrote:
> This patch fix some spelling typo in wilc1000.c.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Please rebase this against my staging-testing branch and resend.

thanks,

greg k-h
