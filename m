Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:9709 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964805Ab3GCTMb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 15:12:31 -0400
Date: Wed, 3 Jul 2013 21:15:12 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/5] rt2x00: rt2800lib: introduce local
 EEPROM access functions
Message-ID: <20130703191512.GB2245@localhost.localdomain> (sfid-20130703_211242_395130_B4C28668)
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
 <1372269318-30233-3-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372269318-30233-3-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 26, 2013 at 07:55:15PM +0200, Gabor Juhos wrote:
> The patch adds rt2800 specific functions for
> EEPROM data access and changes the code to use
> these instead of the generic rt2x00_eeprom_*
> variants.
> 
> To avoid functional changes, the new functions
> are wrappers around the corresponding generic
> rt2x00_eeprom_* routines for now. Functional
> changes will be implemented in additional patches.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

