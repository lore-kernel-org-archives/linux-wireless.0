Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbbFLP2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 11:28:21 -0400
Date: Fri, 12 Jun 2015 08:28:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dean Lee <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: change WILC_Char to s8
Message-ID: <20150612152820.GC26174@kroah.com> (sfid-20150612_172825_478420_910AFD07)
References: <1434087548-11746-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434087548-11746-1-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 12, 2015 at 02:39:08PM +0900, Dean Lee wrote:
> change own data type(WILC_Char) to common data type(s8)

Why not just 'char'?

And you are using these in "strings", so why not u8?

thanks,

greg k-h
