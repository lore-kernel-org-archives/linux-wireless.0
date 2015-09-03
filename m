Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbbICOXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 10:23:51 -0400
Date: Thu, 3 Sep 2015 07:23:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging/wilc1000: Use %pM format specifier to print
 mac address
Message-ID: <20150903142350.GA16857@kroah.com> (sfid-20150903_162430_760698_7B1F27F9)
References: <1441267542-32053-1-git-send-email-kuleshovmail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441267542-32053-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 03, 2015 at 02:05:42PM +0600, Alexander Kuleshov wrote:
> printk() supports %pM format specifier for printing 6-byte MAC/FDDI
> addresses in hex notation small buffers, let's use it intead of %x:%x...
> 
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 6 +++---
>  drivers/staging/wilc1000/linux_wlan.c     | 3 +--
>  2 files changed, 4 insertions(+), 5 deletions(-)

What changed from v1 of this patch?  Please be specific.

thanks,

greg k-h
