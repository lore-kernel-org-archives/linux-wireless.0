Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbbGaDtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 23:49:04 -0400
Date: Thu, 30 Jul 2015 20:49:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH 0/5] 2nd patch for illegal coding style
Message-ID: <20150731034902.GB8945@kroah.com> (sfid-20150731_054908_251199_1039266A)
References: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2015 at 06:10:09PM +0900, Tony Cho wrote:
> This patch V2 includes only patches rejected. The rejected patch for the
> following, #ifdef conditionals cover entire functions, introduced new error on
> required space before the open parenthesis '('. This is my mistake while
> rewriting codes.
> 
> The original 13th patch didn't include new fix introduced on the previous patch
> due to no sync-up issue. The original 13th patch fixed the same warnings but
> in different place. 
> 
> The 64bit compile warnings will be resolved after sending these patches. Then,
> ambiguous sdio/spi parts including preprocessor conditionals will be tried.

Again, please fix the build warnings first, they are much more important
than coding style issues.

thanks,

greg k-h
