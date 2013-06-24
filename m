Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:7574 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab3FXPrP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 11:47:15 -0400
Date: Mon, 24 Jun 2013 17:49:42 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: rt2800: unify [RT]XWI_SIZE
 defines
Message-ID: <20130624154942.GC2460@localhost.localdomain> (sfid-20130624_174718_463544_9F8B49FA)
References: <1371911519-13135-1-git-send-email-juhosg@openwrt.org>
 <1371911519-13135-2-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371911519-13135-2-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 22, 2013 at 04:31:59PM +0200, Gabor Juhos wrote:
> Use common names instead of chip specific ones.
> The patch contains no functional changes, but
> it makes it easier to add support for further
> descriptor sizes.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

