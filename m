Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39299 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3JCUaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 16:30:17 -0400
Date: Thu, 3 Oct 2013 16:21:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] brcmfmac: cleanup and new device support
Message-ID: <20131003202101.GG3142@tuxdriver.com> (sfid-20131003_223026_174712_3406140C)
References: <1380107146-24026-1-git-send-email-arend@broadcom.com>
 <524D543B.7010906@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <524D543B.7010906@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 03, 2013 at 01:25:47PM +0200, Arend van Spriel wrote:
> On 09/25/2013 01:05 PM, Arend van Spriel wrote:
> >This series has a few cleanup patches fixing a sparse error, cleaning
> >up the rx path and also changing the firmware filename approach after
> >getting feedback on this by Stephen Warren. The remaining patches are
> >adding support for the BCM4339 SDIO chipset.
> >
> >This series is intended for v3.13 kernel and applies to the master
> >branch of the wireless-next repository.
> 
> Hi John,
> 
> Did you miss this series from last week?
> 
> Regards,
> Arend

No, just haven't merged everything yet... :-(

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
