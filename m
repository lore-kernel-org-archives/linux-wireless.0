Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48706 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab3GHOKg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:10:36 -0400
Message-ID: <51DAC85D.9050305@openwrt.org> (sfid-20130708_161042_975170_882CF127)
Date: Mon, 08 Jul 2013 16:10:37 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 16/20] rt2x00: rt2800lib: enable VCO
 recalibration for RF3053
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org> <1372664879-18474-17-git-send-email-juhosg@openwrt.org> <20130707144017.GP2073@localhost.localdomain>
In-Reply-To: <20130707144017.GP2073@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.07.07. 16:40 keltezéssel, Stanislaw Gruszka írta:
> On Mon, Jul 01, 2013 at 09:47:55AM +0200, Gabor Juhos wrote:
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
> 
>>  	case RF3290:
>> +	case RF3053:
>>  	case RF5360:
> Nit: sort order.

Also fixed in v3. Thanks!

-Gabor
