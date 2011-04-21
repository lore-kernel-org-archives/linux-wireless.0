Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29640 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1DUTB6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 15:01:58 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 12:01:32 -0700
Date: Thu, 21 Apr 2011 12:01:56 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Naveen Singh <nsingh@atheros.com>
CC: "greg@kroah.com" <greg@kroah.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vipin Mehta <Vipin.Mehta@Atheros.com>,
	"Luis Rodriguez" <Luis.Rodriguez@Atheros.com>,
	Naveen Singh <Naveen.Singh@Atheros.com>,
	Kalle Valo <kalle.valo@atheros.com>
Subject: Re: [PATCH 0/5] staging:ath6kl:patches for supporting 2.1.1 and
 bug fixes
Message-ID: <20110421190156.GG8399@tux>
References: <1302148341-1783-1-git-send-email-nsingh@atheros.cm>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1302148341-1783-1-git-send-email-nsingh@atheros.cm>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 06, 2011 at 08:52:16PM -0700, Naveen Singh wrote:
> From: Naveen Singh <nsingh@atheros.com>
> 
> Greg,
> 
> These are set of 5 patches for ath6kl. These patches are related
> to the correct functionality of driver as well as providing the
> support of 2.1.1 silicon in the upstream driver.
> 
> I have tested each and every patch.With each and every patch I was
> able to compile the kernel, load the kernel, and do a basic connectivity
> test with an external AP.These patches are tested on wireless-testing
> as compared to staging-next because top of staging-next compilation
> was broken. To do this I applied all the patches related to ath6k from 
> staging-next tree to the wireless-testing tree and then I applied these
> patches.
> 
> These should apply cleanly to staging-next tree as well. Let me know if
> you have any issues.
> 
> Naveen Singh (5):
>   staging:at6kl:Support for V2.1.1 Silicon
>   staging:ath6kl: Introduction of new CMD/EVT ID
>   staging:ath6kl:DEV ID in the DATA/CMD Packet
>   staging:ath6kl:Scan operation while disconnect
>   staging:ath6kl:cfg ops for power management

Greg, don't even bother with this series, it no longer applies, we will resend
a new one that applies cleanly to the tree.

  Luis
