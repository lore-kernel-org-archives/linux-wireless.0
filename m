Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61456 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760739Ab2EJSMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 14:12:00 -0400
Received: by pbbrp8 with SMTP id rp8so2209887pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 11:12:00 -0700 (PDT)
Date: Thu, 10 May 2012 11:11:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-wireless@vger.kernel.org,
	florian.c.schilhabel@googlemail.com, ali@internetdog.org,
	netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 0/3] staging: delete duplicated files/functionality in
 rtl8712
Message-ID: <20120510181155.GA8307@kroah.com> (sfid-20120510_201212_783604_F901CBFC)
References: <1336621641-15467-1-git-send-email-paul.gortmaker@windriver.com>
 <20120510165451.GA12958@kroah.com>
 <20120510173139.GA16704@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120510173139.GA16704@windriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 01:31:39PM -0400, Paul Gortmaker wrote:
> [Re: [PATCH 0/3] staging: delete duplicated files/functionality in rtl8712] On 10/05/2012 (Thu 09:54) Greg Kroah-Hartman wrote:
> 
> [...]
> 
> > Can you regenerate these with the full deletion content?  There have
> > been some spelling fixes in these files, and your patches do not apply
> > due to them.  I can hand-edit the patches if you regenerate it.
> > 
> > Or if you rebase on the last linux-next tree, that will pick those
> > changes up and then I can apply these properly.
> 
> I've rebased it onto your staging-next of today, so it should be
> hopefully seamless for you now.

Yes, that was even easier, now pulled and pushed out, thanks.

greg k-h
