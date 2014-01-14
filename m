Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaANVSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 16:18:51 -0500
Date: Tue, 14 Jan 2014 13:19:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: vt6656: sparse fixes: aes_ccmp.c missing
 header.
Message-ID: <20140114211929.GD28705@kroah.com> (sfid-20140114_221854_853094_954B237B)
References: <1389630555.2590.6.camel@canaries32-MCP7A>
 <20140113234614.GA16467@kroah.com>
 <1389733208.8159.9.camel@canaries32-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389733208.8159.9.camel@canaries32-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 14, 2014 at 09:00:08PM +0000, Malcolm Priestley wrote:
> On Mon, 2014-01-13 at 15:46 -0800, Greg KH wrote:
> > On Mon, Jan 13, 2014 at 04:29:15PM +0000, Malcolm Priestley wrote:
> > > Add missing aes_ccmp.h header and move device.h to
> > > aes_ccmp.h
> > 
> > Why move device.h?
> device.h is needed by aes_ccmp.h and only currently gets away with it
> by the include order elsewhere.

Then fix that up first.

> I didn't see the need to include device.h twice or fix
> it with the include order in aes_ccmo.c, there is enough of
> that already in this driver.

Fix it properly, as it will have to be resolved sometime, right?

thanks,

greg k-h
