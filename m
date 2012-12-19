Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:58333 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab2LSJel (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 04:34:41 -0500
Message-ID: <50D18A2D.1010806@openwrt.org> (sfid-20121219_103447_396641_CA9A0A87)
Date: Wed, 19 Dec 2012 10:34:37 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Golle <dgolle@allnet.de>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/2] rt2x00: rt2800pci: verify ioremap
 return value
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org> <20121218215708.GA4825@localhost.localdomain>
In-Reply-To: <20121218215708.GA4825@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.12.18. 22:57 keltezéssel, Stanislaw Gruszka írta:
> On Tue, Dec 18, 2012 at 05:22:22PM +0100, Gabor Juhos wrote:
>> An ioremap call is allowed to fail, however
>> the return value of that is not checked in
>> the 'rt2800pci_read_eeprom_soc' function.
>>
>> The patch adds the missing check, and makes
>> the function return an int value. The patch
>> also converts the 'rt2800_read_eeprom' and
>> 'rt2800_ops.read_eeprom' functions to return
>> an int value, so the error value can be
>> propagated up to the 'rt2800_validate_eeprom'
>> function.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Reviewed-by: Stanislaw Gruszka <stf_xl@wp.pl>

Thanks!

-Gabor

