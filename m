Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914Ab2LLHgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 02:36:45 -0500
Date: Wed, 12 Dec 2012 08:36:28 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <dgolle@allnet.de>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	juhosg@openwrt.org, helmut.schaa@googlemail.com,
	gwingerde@gmail.com, john@phrozen.org
Subject: Re: [PATCH 1/3] rt2x00: allow overriding eeprom through platform_data
Message-ID: <20121212073627.GB2253@redhat.com> (sfid-20121212_083649_006817_57CEF160)
References: <20121211100350.GA7813@earthship.arig>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121211100350.GA7813@earthship.arig>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi 

I have one additional question:

On Tue, Dec 11, 2012 at 12:03:53PM +0200, Daniel Golle wrote:
> +	if (rt2x00_is_soc(rt2x00dev) ||
> +	    test_bit(REQUIRE_EEPROM_FILE, &rt2x00dev->cap_flags))
> +		rt2800pci_read_eeprom_file(rt2x00dev);
Is || correct here ?

Stanislaw

