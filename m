Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54550 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbbEDJTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 05:19:38 -0400
Date: Mon, 4 May 2015 10:19:35 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>, Marek Vasut <marex@denx.de>,
	Anders Larsen <al@alarsen.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: Stable request 9374e7d2 "rtlwifi: rtl8192cu: Add new device ID"
Message-ID: <20150504091935.GD1792@ares.olymp> (sfid-20150504_111942_911539_CE0814E1)
References: <1430230954.6036.4@alarsen-lx>
 <201504281633.17160.marex@denx.de>
 <553FA5F0.1070402@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <553FA5F0.1070402@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 28, 2015 at 10:23:28AM -0500, Larry Finger wrote:
> Please note that there are two commits just added to the mainline repo that
> should be propagated to all stable kernels. Both are addition of new USB IDs
> for an old driver, thus they will cause to side effects. Unfortunately, the
> Cc to stable was missed in the first of these, thus the need for this
> message. The second was Cc for stable, but I include it here for
> completeness.
> 
> The two commits in question are
> 
> commit 9374e7d2fdcad3c36dafc8d3effd554bc702c4b6
> Author: Marek Vasut <marex@denx.de>
> Date:   Thu Mar 26 02:16:06 2015 +0100
> 
>     rtlwifi: rtl8192cu: Add new device ID
> 
>     Add new ID for ASUS N10 WiFi dongle.
> 
> commit 2f92b314f4daff2117847ac5343c54d3d041bf78
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Mon Mar 23 18:14:10 2015 -0500
> 
>     rtlwifi: rtl8192cu: Add new USB ID
> 
>     USB ID 2001:330d is used for a D-Link DWA-131.
> 
>

Thank you, Larry.  Queuing both patches for the 3.16 kernel.

Cheers,
--
Luís

> Thanks,
> 
> Larry
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

