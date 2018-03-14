Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:50633 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbeCNMVU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 08:21:20 -0400
From: "<Hariprasath Elango>" <hariprasath.elango@gmail.com>
Date: Wed, 14 Mar 2018 17:51:07 +0530
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: hariprasath.elango@gmail.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: use kmemdup to replace kmalloc/memcpy
Message-ID: <20180314122107.GA10753@hariprasath> (sfid-20180314_132136_153014_CE262878)
References: <20180313124932.15038-1-hariprasath.elango@gmail.com>
 <20180314113818.GA7169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180314113818.GA7169@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2018 at 12:38:18PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Mar 13, 2018 at 06:19:32PM +0530, hariprasath.elango@gmail.com wrote:
> > From: HariPrasath Elango <hariprasath.elango@gmail.com>
> > 
> > kmalloc followed by memcpy can be replaced by kmemdup.Also added the
> > related error handling part
> > 
> > Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
> > ---
> >  drivers/staging/wilc1000/host_interface.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> You have sent at least 8 patches for this driver over the past day, yet
> I have no idea what order to apply these in at all.
> 
> Please resend them all as a proper patch series, numbered so I have a
> clue as to what order to apply them in.  Also preserve the acks/reviews
> that others have provided so they don't have to provide that again.
> 
> thanks,
> 
> greg k-h

Hi Greg, thanks. Yes I will send a patchset to make things easier for
you keeping in tact the review history

regards,
hari prasath
