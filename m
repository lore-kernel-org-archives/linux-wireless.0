Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbeCNLiU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 07:38:20 -0400
Date: Wed, 14 Mar 2018 12:38:18 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: hariprasath.elango@gmail.com
Cc: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: use kmemdup to replace kmalloc/memcpy
Message-ID: <20180314113818.GA7169@kroah.com> (sfid-20180314_123837_285416_DF6E6FE1)
References: <20180313124932.15038-1-hariprasath.elango@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180313124932.15038-1-hariprasath.elango@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2018 at 06:19:32PM +0530, hariprasath.elango@gmail.com wrote:
> From: HariPrasath Elango <hariprasath.elango@gmail.com>
> 
> kmalloc followed by memcpy can be replaced by kmemdup.Also added the
> related error handling part
> 
> Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

You have sent at least 8 patches for this driver over the past day, yet
I have no idea what order to apply these in at all.

Please resend them all as a proper patch series, numbered so I have a
clue as to what order to apply them in.  Also preserve the acks/reviews
that others have provided so they don't have to provide that again.

thanks,

greg k-h
