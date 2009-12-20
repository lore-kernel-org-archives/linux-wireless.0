Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:47293 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbZLTWZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 17:25:34 -0500
Received: by ywh12 with SMTP id 12so5109273ywh.21
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2009 14:25:32 -0800 (PST)
Message-ID: <4B2EA45A.3060507@lwfinger.net>
Date: Sun, 20 Dec 2009 16:25:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Clear PCI configuration reg. 0x41 to avoid	interference
 with C3 processor state
References: <4b2daf91.VB5IdAW/+fSDNPPV%Larry.Finger@lwfinger.net>
In-Reply-To: <4b2daf91.VB5IdAW/+fSDNPPV%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/19/2009 11:01 PM, Larry Finger wrote:
> In exploring the cause of DMA errors for BCM4312 devices on Atom
> processors, other drivers that work write to PCI configuration
> register 0x40. The code fragment below was found in the open-code
> portion of the Broadcom hybrid wl driver. It is also used in the
> ipw2100 and ath9k drivers. In the latter case, it had been removed
> and later restored to prevent fatal interrupt errors.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> I think this is 2.6.34 material. By itself, it does not affect the
> DMA errors in BCM4312 devices. If it is found to help in the resolution
> of that long-standing problem, I will request a change in the status.
> 
> Larry
> ---

John,

Please consider this patch retracted. If I actually find that it helps
some system, I'll resubmit it then.

Larry

