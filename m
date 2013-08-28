Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab3H1FCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 01:02:42 -0400
Date: Tue, 27 Aug 2013 22:05:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Update e-mail address for Andrea Merello
Message-ID: <20130828050501.GA10154@kroah.com> (sfid-20130828_070301_100126_A93FEE03)
References: <1377518010-14767-1-git-send-email-andrea.merello@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377518010-14767-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 26, 2013 at 01:53:30PM +0200, Andrea Merello wrote:
> A lot of files contain reference to my old e-mail address.
> Now I'm going not to read mail from it anymore, so update it
> with my current address everywhere.
> 
> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>

I stripped out and took only the drivers/staging/* changes in this
patch.  I'd recommend resending all the drivers/net/wireless/ changes to
the linux-wireless@ group again, so they can apply just those changes.

thanks,

greg k-h
