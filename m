Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49030 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbbJDJQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 05:16:52 -0400
Date: Sun, 4 Oct 2015 12:16:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chandra S Gorentla <csgorentla@gmail.com>, johnny.kim@atmel.com,
	rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers: staging: wilc1000: Call kfree only for
 error cases
Message-ID: <20151004091631.GS7289@mwanda> (sfid-20151004_111716_112695_D570213D)
References: <1443864450-18167-1-git-send-email-csgorentla@gmail.com>
 <1443864450-18167-2-git-send-email-csgorentla@gmail.com>
 <20151004084457.GB24589@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151004084457.GB24589@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 04, 2015 at 09:44:57AM +0100, Greg KH wrote:
> Aren't you now leaking memory as you aren't freeing pstrMessage and the
> buffer on the "normal" return path?

It's supposed to.  It's a bug fix.  I explained to him in the first
version that his changelog sucks.

regards,
dan carpenter

