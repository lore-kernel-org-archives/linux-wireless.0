Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbJQFBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 01:01:09 -0400
Date: Fri, 16 Oct 2015 22:01:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 01/13] staging: wilc1000: add wilc to netdev private data
 structure
Message-ID: <20151017050108.GA12184@kroah.com> (sfid-20151017_070112_764734_F4590C4F)
References: <1444987389-14151-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444987389-14151-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 16, 2015 at 06:22:57PM +0900, Tony Cho wrote:
> From: Glen Lee <glen.lee@atmel.com>
> 
> This patch adds struct wilc to struct perInterface_wlan_t which is netdev
> private data to access wilc via netdev_priv function and assigns wilc to
> nic->wilc. The global variable wl will be replaced with netdev private data
> member wilc step by step.

Nice, this is a great series, but it doesn't apply :(

Please fix up and resend.

thanks,

greg k-h
