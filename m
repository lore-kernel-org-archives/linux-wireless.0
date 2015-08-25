Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:36504 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbbHYXZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 19:25:36 -0400
Received: by qkda128 with SMTP id a128so60390975qkd.3
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2015 16:25:36 -0700 (PDT)
From: Sreenath Madasu <sreenath.madasu@gmail.com>
Date: Tue, 25 Aug 2015 19:25:03 -0400
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Getting started on switching rtl8188eu staging driver to
 LIB80211/MAC80211
Message-ID: <20150825232503.GA3342@sreenath-gentoo.lan> (sfid-20150826_012540_001525_BB751571)
References: <loom.20150824T013723-25@post.gmane.org>
 <55DB2D62.6090002@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55DB2D62.6090002@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Larry,
I will look at those drivers
Sreenath
On Mon, Aug 24, 2015 at 09:42:42AM -0500, Larry Finger wrote:
> On 08/23/2015 06:40 PM, Sreenath Madasu wrote:
> > Hi all,
> > I want to work on the TODO tasks
> >
> > - switch to use LIB80211
> > - switch to use MAC80211
> >
> > for staging driver rtl8188eu.
> >
> > How can I start? Where is the documentation?
> 
> There is no specific documentation for this device, only what is available in 
> the mac80211, cfg80211, and nl80211 code. You could also look at the drivers in 
> drivers/net/wireless/ for ideas. The driver must be rewritten. You could 
> consider Jes Sorensen's work on producing a mac80211 driver for the RTL8723AU 
> that has been posted on this mailing list. He started with a Realtek USB driver 
> that is similar to r8188eu.
> 
> Larry
> 
> 
