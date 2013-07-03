Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:9581 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964947Ab3GCTLg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 15:11:36 -0400
Date: Wed, 3 Jul 2013 21:14:17 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/5] rt2x00: rt2800lib: introduce
 rt2800_eeprom_word enum
Message-ID: <20130703191417.GA2245@localhost.localdomain> (sfid-20130703_211206_619462_4B967140)
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
 <1372269318-30233-2-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372269318-30233-2-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 26, 2013 at 07:55:14PM +0200, Gabor Juhos wrote:
> The patch converts the EEPROM_* word address defines
> into new enum values. The new enum type will be used
> by new functions which will be introduced in subsequent
> changes.
> 
> The patch contains no functional changes.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

