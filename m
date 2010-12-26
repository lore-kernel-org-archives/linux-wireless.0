Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47334 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab0LZF1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 00:27:36 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikcTSgjdxR106H2XZdmepN40bTKfEgmP04OQAz3@mail.gmail.com>
References: <AANLkTi=aHU57xDq+-DWrN2sJsAwx_9bZ_ofy1rOmp0VH@mail.gmail.com>
 <Pine.LNX.4.44L0.1012251046060.5079-100000@netrider.rowland.org>
 <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com> <AANLkTikcTSgjdxR106H2XZdmepN40bTKfEgmP04OQAz3@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 26 Dec 2010 07:27:15 +0200
Message-ID: <AANLkTin5=PJ35b0Oaj09wHDqR2h=Zb42WyV7Hy-BkAC5@mail.gmail.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 25, 2010 at 11:50 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
> you're talking about _complete_ shutdown as a suspended state for both
> runtime PM and static PM, is that correct?

Exactly.

This is the power of the card as seen by the MMC/SDIO subsystem.
