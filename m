Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:54871 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3AQVYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 16:24:53 -0500
Received: by mail-ea0-f176.google.com with SMTP id a13so920655eaa.21
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2013 13:24:52 -0800 (PST)
Message-ID: <1358457883.5641.7.camel@canaries64> (sfid-20130117_222457_303011_88648EA2)
Subject: Re: [PATCH 3/3] staging: vt6656: staging: vt6656 change remaining
 to vnt_mgmt and remove typedef v2
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Jan 2013 21:24:43 +0000
In-Reply-To: <20130117211256.GA23334@kroah.com>
References: <1357602156.12182.11.camel@canaries64>
	 <20130117211256.GA23334@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-17 at 13:12 -0800, Greg KH wrote:
> On Mon, Jan 07, 2013 at 11:42:36PM +0000, Malcolm Priestley wrote:
> > 
> > rebased version
> > 
> > after this patch continue on wards with
> > [10/11] staging: vt6656: clean up struct vnt_private.
> > [11/11] staging: vt6656: clean up struct vnt manager
> 
> What do you mean by this?  Can you please just send the entire series of
> patches?  I don't have these anymore in any tree.  For now, I'll just
> drop all of these and wait for your resend.
> 

Part of the series is already in staging-next.

However, the driver is currently broken in staging-next, these three
patches bring the driver up.

Those two clean up patches can be dropped for now, and I will resend
them later.


Malcolm



