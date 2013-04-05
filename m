Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161177Ab3DENbx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 09:31:53 -0400
Date: Fri, 5 Apr 2013 15:32:34 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 2/6] rt2x00: rt2400pci: use the rt2x00mmio_* routines
Message-ID: <20130405133234.GB1571@redhat.com> (sfid-20130405_153155_640769_067F18B0)
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
 <1365143225-24532-3-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365143225-24532-3-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 05, 2013 at 08:27:01AM +0200, Gabor Juhos wrote:
> Use the recently introduced rt2x00mmio_* routines
> instead of the rt2x00pci_* variants.
> 
> The patch contains no functional changes.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>  drivers/net/wireless/rt2x00/rt2400pci.c |  309 ++++++++++++++++---------------

Why do you modify rt2400pci ?

Stanislaw
