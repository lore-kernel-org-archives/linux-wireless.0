Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:35348 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbbFATCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 15:02:38 -0400
Date: Mon, 1 Jun 2015 22:02:31 +0300
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: wilc1000: Fix some compile warnings
Message-ID: <20150601190231.GA2631@kholmanskikh> (sfid-20150601_210257_124401_E91943C2)
References: <1433018659-25958-1-git-send-email-kholmanskikh.s.s@gmail.com>
 <20150530235941.GB20036@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150530235941.GB20036@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On Sun, May 31, 2015 at 08:59:41AM +0900, Greg KH wrote:
> On Sat, May 30, 2015 at 11:44:18PM +0300, Stanislav Kholmanskikh wrote:
> > This patch reduces (a little bit) the amount of compile time
> > warnings.
> > 
> > The change of WILC_WFI_init_mon_interface() prototype seems to be ok,
> > because alloc_netdev() also expects 'const char *name'.
> 
> You are doing different types of fixes here, please be explicit about
> what you are doing and break this up into logical patches that each only
> do one type of thing.

Thank you for review.

I've just sent an updated version which addresses your comments.

Thanks.

> 
> thanks,
> 
> greg k-h
