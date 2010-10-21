Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:50276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab0JUSa2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 14:30:28 -0400
Date: Thu, 21 Oct 2010 11:26:48 -0700
From: Greg KH <greg@kroah.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Nohee Ko <noheek@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Brett Rudley <brudley@broadcom.com>,
	"grundler@google.com" <grundler@google.com>,
	linux-wireless@vger.kernel.org, dwmw2@infradead.org
Subject: Re: Subject: [PATCH] staging: brcm80211: brcmfmac: Removed
 codeversion from firmware filenames.
Message-ID: <20101021182648.GA6827@kroah.com>
References: <4CBE23F4.4020104@broadcom.com>
 <20101019233520.GA12510@kroah.com>
 <FD96C117992C584DBC47231B1EB6F5568206D859DC@SJEXCHCCR02.corp.ad.broadcom.com>
 <20101020004743.GB31965@kroah.com>
 <20101020005546.GL10832@broadcom.com>
 <20101020010320.GA370@kroah.com>
 <20101021171054.GB15357@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101021171054.GB15357@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 21, 2010 at 10:10:55AM -0700, Henry Ptasinski wrote:
> The basename-apiversion-codeversion construction for firmware filenames is not
> used by most other firmware files, adds complexity, and is not providing any
> value.  Rename the firmware files using just basename-apiversion.
> 
> Users of the brcmfmac driver will need to update the linux-firmware package
> to get the renamed files, or manually rename their installed firmware files.
> ---
>  drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

-ENOSIGNED-OFF-BY-LINE :(

