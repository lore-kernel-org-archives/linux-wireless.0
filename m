Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbbJQEdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 00:33:51 -0400
Date: Fri, 16 Oct 2015 21:33:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 03/16] staging: wilc1000: rename g_linux_wlan to wl
Message-ID: <20151017043349.GA23351@kroah.com> (sfid-20151017_063354_398329_6FB6B488)
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
 <1444823204-16736-3-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444823204-16736-3-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2015 at 08:46:31PM +0900, Tony Cho wrote:
> This patch renames g_linux_wlan to wl.

Why?  What's wrong with g_linux_wlan?  You will need to delete this
entire variable soon anyway, might as well leave it alone until then.

thanks,

greg k-h
