Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759103Ab0KPUHw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 15:07:52 -0500
Date: Tue, 16 Nov 2010 12:04:20 -0800
From: Greg KH <greg@kroah.com>
To: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: brcm80211: brcmfmac: remove PCI SDIO
 controller binding
Message-ID: <20101116200420.GA10793@kroah.com>
References: <cover.1289734125.git.mike.rapoport@gmail.com>
 <df8061ebab7c953f3f4aa438d426dce7aa1bd8e1.1289734125.git.mike.rapoport@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <df8061ebab7c953f3f4aa438d426dce7aa1bd8e1.1289734125.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 14, 2010 at 01:36:22PM +0200, Mike Rapoport wrote:
> Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
> ---
>  drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |  229 ---------------------

This patch doesn't apply, care to redo it and resend it?

thanks,

greg k-h
