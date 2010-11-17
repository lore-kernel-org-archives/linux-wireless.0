Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:58752 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933693Ab0KQVV4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 16:21:56 -0500
Date: Wed, 17 Nov 2010 13:10:35 -0800
From: Greg KH <greg@kroah.com>
To: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: brcm80211: brcmfmac: remove PCI SDIO
 controller binding
Message-ID: <20101117211035.GA2442@kroah.com>
References: <20101116200420.GA10793@kroah.com>
 <1289980726-28706-1-git-send-email-mike.rapoport@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1289980726-28706-1-git-send-email-mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 09:58:46AM +0200, Mike Rapoport wrote:
> Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
> ---
>  drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |  229 ---------------------
>  1 files changed, 0 insertions(+), 229 deletions(-)

Wait, is this really ok code to be removing from the driver?

Brett and Henry, any objections to this?

Mike, why do you think this is ok to remove?  Is it because no one is
ever calling this even for both types of config for this driver?

thanks,

greg k-h
