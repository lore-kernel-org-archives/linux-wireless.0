Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42702 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3AQVyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 16:54:05 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1645389pbc.33
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2013 13:54:03 -0800 (PST)
Date: Thu, 17 Jan 2013 13:54:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: vt6656: staging: vt6656 change remaining to
 vnt_mgmt and remove typedef v2
Message-ID: <20130117215400.GA9147@kroah.com> (sfid-20130117_225410_065141_8286BB48)
References: <1357602156.12182.11.camel@canaries64>
 <20130117211256.GA23334@kroah.com>
 <1358457883.5641.7.camel@canaries64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358457883.5641.7.camel@canaries64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 17, 2013 at 09:24:43PM +0000, Malcolm Priestley wrote:
> On Thu, 2013-01-17 at 13:12 -0800, Greg KH wrote:
> > On Mon, Jan 07, 2013 at 11:42:36PM +0000, Malcolm Priestley wrote:
> > > 
> > > rebased version
> > > 
> > > after this patch continue on wards with
> > > [10/11] staging: vt6656: clean up struct vnt_private.
> > > [11/11] staging: vt6656: clean up struct vnt manager
> > 
> > What do you mean by this?  Can you please just send the entire series of
> > patches?  I don't have these anymore in any tree.  For now, I'll just
> > drop all of these and wait for your resend.
> > 
> 
> Part of the series is already in staging-next.
> 
> However, the driver is currently broken in staging-next, these three
> patches bring the driver up.
> 
> Those two clean up patches can be dropped for now, and I will resend
> them later.

Please send whatever needs to be done to get it working again, I can't
accept this format, it doesn't make any sense.

thanks,

greg k-h
