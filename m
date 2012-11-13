Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39706 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2KMVab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 16:30:31 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so4266245eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 13:30:29 -0800 (PST)
Message-ID: <1352842218.8169.11.camel@user64-MCP7A> (sfid-20121113_223034_453614_FB57136E)
Subject: Re: [PATCH 08/14] staging: vt6656: 64 bit fixes : correct all type
 sizes
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Nov 2012 21:30:18 +0000
In-Reply-To: <20121113205035.GB27716@kroah.com>
References: <1352648485.6460.16.camel@canaries32-MCP7A>
	 <20121113205035.GB27716@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-13 at 12:50 -0800, Greg KH wrote:
> On Sun, Nov 11, 2012 at 03:41:25PM +0000, Malcolm Priestley wrote:
> >  /****** Common pointer types ***********************************************/
> >  
> > -typedef unsigned long   ULONG_PTR;      // 32-bit
> > -typedef unsigned long   DWORD_PTR;      // 32-bit
> > +typedef u32 ULONG_PTR;
> > +typedef u32 DWORD_PTR;
> 
> A pointer does not fit in u32 on all arches, only unsigned long works
> here.
> 
Hi

The naming is misleading, they are not pointers.

I have a upcoming patch to remove them.

Regards


Malcolm


