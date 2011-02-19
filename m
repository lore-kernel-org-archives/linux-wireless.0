Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58020 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1BSJ0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 04:26:20 -0500
Received: by fxm20 with SMTP id 20so4674128fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 01:26:19 -0800 (PST)
Date: Sat, 19 Feb 2011 12:26:10 +0300
From: Stanislav Fomichev <kernel@fomichev.me>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org, brudley@broadcom.com,
	gregkh@suse.de
Subject: Re: [PATCH 1/8] brcm80211: replace dot11_header with ieee80211_hdr
Message-ID: <20110219092609.GB1828@sdf-MacBook>
References: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
 <20110218205815.GE796@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110218205815.GE796@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 18, 2011 at 12:58:15PM -0800, Greg KH wrote:
> On Sun, Feb 13, 2011 at 05:40:36PM +0300, Stanislav Fomichev wrote:
> > This is a series of patches which remove brcm specific definitions.
> > Tested on MacBook 7.1.
> > 
> > Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
> > ---
> >  drivers/staging/brcm80211/include/proto/802.11.h |   10 ----
> >  drivers/staging/brcm80211/sys/wlc_ampdu.c        |   18 +++---
> >  drivers/staging/brcm80211/sys/wlc_mac80211.c     |   64 +++++++++++-----------
> 
> You really need to do this against linux-next, as I can't apply any of
> these patches.
> 
> Care to respin them and resend?
This is, again, based on the wrong tree. Pls drop. Thanks!

-- 
	Stas
