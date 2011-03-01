Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63641 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab1CAQD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 11:03:57 -0500
Received: by iyb26 with SMTP id 26so4020250iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 08:03:56 -0800 (PST)
Date: Tue, 1 Mar 2011 19:03:16 +0300
From: Dan Carpenter <error27@gmail.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
	Dowan Kim <dowan@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, arend@broadcom.com
Subject: Re: [PATCH 2/2] staging: brcm80211: Remove unused variables and
 code clean up
Message-ID: <20110301160316.GT18043@bicker>
References: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
 <1298840055-5044-2-git-send-email-martinez.javier@gmail.com>
 <20110301031151.GA7620@kroah.com>
 <AANLkTi=zU-F=y2qn6B90F3esbNVkE6_nCOZS-dnTA4en@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=zU-F=y2qn6B90F3esbNVkE6_nCOZS-dnTA4en@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 01, 2011 at 04:37:55PM +0100, Javier Martinez Canillas wrote:
> >> ---
> >>  drivers/staging/brcm80211/brcmsmac/wlc_mac80211.c |    9 ---------
> >
> > This doesn't apply anymore, care to redo it and resend?
> >
> > thanks,
> 
> Sure Greg but I tried with today linux-next and the patch applies
> cleanly. Maybe the problem are some patches that you have but haven't
> reached linux-next yet.
> 
> Do you want me to wait a few days to redo and resend it or am I doing
> something wrong?

Actually Arend has a different patch for this, that I guess fixes the
#if 0 code instead of removing it.  Probably that's prefered.  I've
asked him to submit it.

regards,
dan carpenter
