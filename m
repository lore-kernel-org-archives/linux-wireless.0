Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:28843 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab3FXPqs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 11:46:48 -0400
Date: Mon, 24 Jun 2013 17:49:14 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/2] rt2x00: rt2800pci: don't use
 TXWI_DESC_SIZE directly
Message-ID: <20130624154846.GB2460@localhost.localdomain> (sfid-20130624_174652_186236_30C4198B)
References: <1371911519-13135-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371911519-13135-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 22, 2013 at 04:31:58PM +0200, Gabor Juhos wrote:
> Different chipsets may use different TXWI descriptor
> size. Instead of using a hardcoded value, use the
> 'queue->winfo_size' which holds the correct value for
> a given device.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

