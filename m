Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbbI2BX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 21:23:56 -0400
Date: Tue, 29 Sep 2015 02:44:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: dan.carpenter@oracle.com, johnny.kim@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 1/2] drivers: staging: wilc1000: Replace message queue
 with standard Linux lists
Message-ID: <20150929004402.GB7811@kroah.com> (sfid-20150929_032418_202284_A1C30C48)
References: <1443464037-3591-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443464037-3591-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 28, 2015 at 11:43:55PM +0530, Chandra S Gorentla wrote:
>  - The message queue is replaced with standard Linux linked list
>  - kmem_cache is used for list members

Why?

>  - A check for return value of receive method is added
>  - GFP_ATOMIC is changed to GFP_KERNEL

Why?  Are you sure that is safe?

>  - A few other related minor changes

Be specific please.

thanks,

greg k-h
