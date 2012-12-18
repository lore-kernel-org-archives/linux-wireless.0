Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:22750 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab2LRV5T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2012 16:57:19 -0500
Date: Tue, 18 Dec 2012 22:57:08 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Golle <dgolle@allnet.de>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/2] rt2x00: rt2800pci: verify ioremap
 return value
Message-ID: <20121218215708.GA4825@localhost.localdomain> (sfid-20121218_225724_559367_BE50F033)
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1355847743-16659-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 18, 2012 at 05:22:22PM +0100, Gabor Juhos wrote:
> An ioremap call is allowed to fail, however
> the return value of that is not checked in
> the 'rt2800pci_read_eeprom_soc' function.
> 
> The patch adds the missing check, and makes
> the function return an int value. The patch
> also converts the 'rt2800_read_eeprom' and
> 'rt2800_ops.read_eeprom' functions to return
> an int value, so the error value can be
> propagated up to the 'rt2800_validate_eeprom'
> function.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Reviewed-by: Stanislaw Gruszka <stf_xl@wp.pl>

