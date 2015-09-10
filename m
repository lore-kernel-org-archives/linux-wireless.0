Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbIJFIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 01:08:01 -0400
Date: Wed, 9 Sep 2015 22:07:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 3/4] staging: wilc1000: delete wilc_oswrapper.h and
 wilc_platform.h
Message-ID: <20150910050754.GA14718@kroah.com> (sfid-20150910_070804_692602_C07950D4)
References: <1441782493-11338-1-git-send-email-tony.cho@atmel.com>
 <1441782493-11338-3-git-send-email-tony.cho@atmel.com>
 <20150909181912.GA30669@kroah.com>
 <55F0E619.5000808@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55F0E619.5000808@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 10, 2015 at 11:08:25AM +0900, Tony Cho wrote:
> Hi Greg,
> 
> I want to make sure one thing before moving further. Are you saying
> the errorsupport.h file as the os wrapper remaining in the oswrapper.h
> file?  If not, can you let me know what you point out as remaining os
> wrapper in the oswrapper.h file?

I don't remember at this point in time, sorry, that was a few hundred
patches I reviewed ago, and 5 hours of meetings after that...

> If yes, I have been already replacing all of error values defined in
> the errorsupport.h file so that I send you the next patch when done.

That would be good to have.

I think my point was that you can't just move things from a .h file to
another .h file, clean up the os wrappers by removing them entirely,
like I did with the other wrapper functions for delays and other things.

thanks,

greg k-h
