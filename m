Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbbHQTwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 15:52:06 -0400
Date: Mon, 17 Aug 2015 12:52:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/4] staging: wilc1000: delete wilc_osconfig.h
Message-ID: <20150817195205.GA6430@kroah.com> (sfid-20150817_215210_064800_B238197D)
References: <1439819071-30000-1-git-send-email-chaehyun.lim@gmail.com>
 <1439819071-30000-2-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439819071-30000-2-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2015 at 10:44:29PM +0900, Chaehyun Lim wrote:
> The macros inside wilc_osconfig.h are not referenced anywhere,
> so just delete it.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>

And I did this one also, again, sorry, I hadn't seen your email yet.

greg k-h
