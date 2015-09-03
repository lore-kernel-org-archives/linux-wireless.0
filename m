Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212AbbICSlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 14:41:51 -0400
Date: Thu, 3 Sep 2015 11:41:50 -0700
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
Message-ID: <20150903184150.GA31230@kroah.com> (sfid-20150903_204210_406278_41B8DFFE)
References: <20150903142350.GA16857@kroah.com>
 <1441305338-10280-1-git-send-email-kuleshovmail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441305338-10280-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 04, 2015 at 12:35:38AM +0600, Alexander Kuleshov wrote:
> printk() supports %pM format specifier for printing 6-byte MAC/FDDI
> addresses in hex notation small buffers, let's use it intead of %x:%x...
> 
> Changelog:
> 
> v1 -> v2:
> 
> * In the first version of the patch was instruduced incorrect conversion,
> now there is previous formatting in the WILC_WFI_mon_xmit().

changelog doesn't belong here in the body of the text, it should be
below the --- line so it doesn't get committed into git.

thanks,

greg k-h
