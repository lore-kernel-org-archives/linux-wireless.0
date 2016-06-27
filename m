Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:51738 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbcF0VWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 17:22:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 01/10] rtlwifi: Create common routine to get hardware info
Date: Mon, 27 Jun 2016 23:25:16 +0200
Message-ID: <4622977.lUv4YbxP2P@wuerfel> (sfid-20160627_232258_214268_E059F639)
In-Reply-To: <1467042758-25742-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1467042758-25742-1-git-send-email-Larry.Finger@lwfinger.net> <1467042758-25742-2-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, June 27, 2016 10:52:29 AM CEST Larry Finger wrote:
> All of the rtlwifi family of drivers have a similar routine that acquires
> the hardware info from efuse and initializes a number of variables in the
> driver's private area. A common routine is created for all drivers to use.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
> V2 - Fixes bug found after V1 was submitted.
>      Incorporates change suggested by Joe Perches
> 
> This patch requires ("rtlwifi: Add missing newlines to RT_TRACE calls")
>         submitted by Joe Perches.
> 

Thanks for the follow-up on my suggestion!

The changes look good, though I'm not really qualified to say whether
they are correct.

	Arnd

