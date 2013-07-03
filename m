Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:38748 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964986Ab3GCT0C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 15:26:02 -0400
Date: Wed, 3 Jul 2013 21:28:42 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 5/5] rt2x00: rt2800lib: add EEPROM map for
 the RT3593 chipset
Message-ID: <20130703192842.GE2245@localhost.localdomain> (sfid-20130703_212606_315489_0AA27F52)
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
 <1372269318-30233-6-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372269318-30233-6-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 26, 2013 at 07:55:18PM +0200, Gabor Juhos wrote:
> Three-chain devices are using a different
> EEPROM layout than the rest of the chipsets.
> Add a new map which describes the new layout
> and use that for the RT3593 chipset.
> 
> The index values has been computed from the
> EEPROM_EXT_* defines, which can be found in
> the 'include/chip/rt3593.h' file in the
> Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
> driver.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
