Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbbJQEf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 00:35:26 -0400
Date: Fri, 16 Oct 2015 21:35:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 05/16] staging: wilc1000: change the type of
 wilc1000_initialized
Message-ID: <20151017043525.GA30682@kroah.com> (sfid-20151017_063528_468949_A4CCA3AD)
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
 <1444823204-16736-5-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444823204-16736-5-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2015 at 08:46:33PM +0900, Tony Cho wrote:
> This patch changes the type of wilc1000_initialized in the struct wilc from
> int to bool and renames it to the initialized. In addition, the unncessary
> wilc1000_initialized codes are removed in this patch.

because I didn't take the rename patch, this one didn't apply, so I've
stopped here in the patch series.

thanks,

greg k-h
