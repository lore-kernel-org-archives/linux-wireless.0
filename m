Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbbFOCeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 22:34:13 -0400
Date: Sun, 14 Jun 2015 19:34:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Dean.lee" <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: change WILC_Char to s8
Message-ID: <20150615023412.GA31318@kroah.com> (sfid-20150615_043416_690253_EBCFD5A8)
References: <1434087548-11746-1-git-send-email-dean.lee@atmel.com>
 <20150612152820.GC26174@kroah.com>
 <557E2088.10008@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <557E2088.10008@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 15, 2015 at 09:47:04AM +0900, Dean.lee wrote:
> 
> 
> On 2015년 06월 13일 00:28, Greg KH wrote:
> >On Fri, Jun 12, 2015 at 02:39:08PM +0900, Dean Lee wrote:
> >>change own data type(WILC_Char) to common data type(s8)
> >Why not just 'char'?
> >
> >And you are using these in "strings", so why not u8?
> >
> >thanks,
> >
> >greg k-h
> i research some documents for change to common data type.
> that's saying 's8' is 'signed char'.
> 
> 'WILC_Char' is redefine 'char'. so i changed 'WILC_Char' to 's8'

Then stick to 'char', don't change the type.

thanks,

greg k-h
