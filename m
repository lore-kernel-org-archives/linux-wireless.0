Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48934 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2KMVvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 16:51:39 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so101191pbc.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 13:51:39 -0800 (PST)
Date: Tue, 13 Nov 2012 13:51:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/14] staging: vt6656: 64 bit fixes : correct all type
 sizes
Message-ID: <20121113215135.GA16020@kroah.com> (sfid-20121113_225143_298821_C73707BF)
References: <1352648485.6460.16.camel@canaries32-MCP7A>
 <20121113205035.GB27716@kroah.com>
 <1352842218.8169.11.camel@user64-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1352842218.8169.11.camel@user64-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 13, 2012 at 09:30:18PM +0000, Malcolm Priestley wrote:
> On Tue, 2012-11-13 at 12:50 -0800, Greg KH wrote:
> > On Sun, Nov 11, 2012 at 03:41:25PM +0000, Malcolm Priestley wrote:
> > >  /****** Common pointer types ***********************************************/
> > >  
> > > -typedef unsigned long   ULONG_PTR;      // 32-bit
> > > -typedef unsigned long   DWORD_PTR;      // 32-bit
> > > +typedef u32 ULONG_PTR;
> > > +typedef u32 DWORD_PTR;
> > 
> > A pointer does not fit in u32 on all arches, only unsigned long works
> > here.
> > 
> Hi
> 
> The naming is misleading, they are not pointers.

Ah, but of course :)

> I have a upcoming patch to remove them.

Ok, that sounds good.

greg k-h
