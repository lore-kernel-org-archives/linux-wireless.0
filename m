Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbbGGEAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 00:00:35 -0400
Date: Mon, 6 Jul 2015 19:21:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dean Lee <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	rachel.kim@atmel.com, chris.park@atmel.com,
	nicolas.ferre@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH 2/6] staging: wilc1000: delete 'WILC_WFIDrvHandle'
 structure
Message-ID: <20150707022118.GC12574@kroah.com> (sfid-20150707_060043_955894_B3A031AC)
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
 <1435653278-5168-2-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435653278-5168-2-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2015 at 05:34:34PM +0900, Dean Lee wrote:
> delete odd structure and rework it.

what do you mean by "rework it"?  It looks like you just made it a void
* everywhere, which is what I explicitly said to not do.

sorry, can't take this.

greg k-h
