Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:36994 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab0LPJCE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 04:02:04 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oBG90Xcl024561
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:02:03 +0200
Subject: Re: [PATCH v2] wl12xx_sdio_test: rename files to match current
 style
From: Luciano Coelho <luciano.coelho@nokia.com>
To: Roger Quadros <roger.quadros@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4D08DBDC.5070908@nokia.com>
References: <1292423499-5667-1-git-send-email-luciano.coelho@nokia.com>
	 <1292423633.32385.9.camel@chilepepper>
	 <1292424501.32385.10.camel@chilepepper>  <4D08DBDC.5070908@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 11:04:07 +0200
Message-ID: <1292490247.11205.14.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Roger,

On Wed, 2010-12-15 at 17:16 +0200, Roger Quadros wrote:
> On 12/15/2010 04:48 PM, Luciano Coelho wrote:
> > On Wed, 2010-12-15 at 16:33 +0200, ext Luciano Coelho wrote:
> >> On Wed, 2010-12-15 at 16:31 +0200, luciano.coelho@nokia.com wrote:
> >>> From: Luciano Coelho<luciano.coelho@nokia.com>
> >>>
> >>> Change some file names and Kconfig settings so that this new module matches
> >>> the new way of using wl12xx instead of wl1271.
> >>>
> >>> Also fix SDIO power enabling and disabling to match the latest way of doing
> >>> it.
> >>>
> >>> Cc: Roger Quadros<roger.quadros@nokia.com>
> >>> Signed-off-by: Luciano Coelho<luciano.coelho@nokia.com>
> >>> ---
> >>
> >> In v2 I used the -M flag (to detect renames, which I stupidly forgot
> >> before) and removed the file names from the header of the sdio_test.c
> >> file, since it's a bad idea to have it there (thanks Johannes for the
> >> comments).
> >
> > Roger, I have just compile-tested this module in upstream.  Could you
> > run at least some basic tests with it to make sure it works?
> >
> >
> 
> Luca,
> 
> I don't have a ready setup with me which boots mainline kernel and has wl1271 on 
> sdio.

I have a tree prepared with the latest wl12xx.git plus some patches that
add support for our development platform (RX-71).


> The only way to verify it is to load the module with the parameters rx=1 and 
> tx=1 and see if the "testing started" message appears.

I tried it now, but I'm always getting this when loading the module:

[  114.883514] wl12xx_sdio_test mmc2:0001:2: could not wake up chip
[  114.889587] wl12xx_sdio_test: probe of mmc2:0001:2 failed with error 1

Any clue what this is about?


> what platform do you use to verify with mainline kernel & sdio wl1271 ?

I use both our RX-71 and a Beagleboard.  I have trees which work on
both, let me know if you want to clone them from my local git.

-- 
Cheers,
Luca.

