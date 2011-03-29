Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1C2SaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 14:30:11 -0400
Date: Tue, 29 Mar 2011 14:30:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	rmk+kernel@arm.linux.org.uk, gregkh@suse.de,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 0/1] new module for amba axi on-chip interconnect
Message-ID: <20110329183010.GB22898@infradead.org>
References: <1301391619-4499-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1301391619-4499-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 29, 2011 at 11:40:18AM +0200, Arend van Spriel wrote:
> GUIDANCE NEEDED:
> This patch puts the module at proposed location. Please provide your
> guidance if there is a better location within the linux tree for this
> module.
> 
> This module has been isolated from the brcm80211 driver currently
> located in staging and provided to other drivers for chipsets using
> the AMBA AXI on-chip interconnect with ARM Device Management Plugin
> (DMP) silicon IP, which provides system discovery (chip being the
> system) and basic core function (disable, reset, etc.).

Any reason this is not integrated with drivers/amba?

