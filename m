Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbcDCSlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2016 14:41:24 -0400
Date: Sun, 3 Apr 2016 11:41:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: mohammed.billoo@gmail.com
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ensure that comments adhere to coding standard
Message-ID: <20160403184123.GA12414@kroah.com> (sfid-20160403_204144_211884_7F533251)
References: <1459707526-21124-1-git-send-email-mohammed.billoo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459707526-21124-1-git-send-email-mohammed.billoo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 03, 2016 at 02:18:46PM -0400, mohammed.billoo@gmail.com wrote:
> From: Mohammed Billoo <mohammed.billoo@gmail.com>
> 
> Files in wilc1000 were modified to ensure that comments
> adhere to standard specified by Documentation/CodingStyle
> 
> Signed-off-by: Mohammed Billoo <mohammed.billoo@gmail.com>

Please put the subsystem and driver in your subject: as we have no idea
what this is referring to otherwise.  Look at the other patches that
have been accepted for this driver to see examples of how to do that by
running:
	git log drivers/staging/wilc1000

Also, note that this is a network driver, so the comments here are
already in the correct format, so I don't think this patch is needed at
all, do you?

thanks,

greg k-h
