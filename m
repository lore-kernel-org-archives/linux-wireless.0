Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48530 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3GHOKD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:10:03 -0400
Message-ID: <51DAC83D.4020306@openwrt.org> (sfid-20130708_162043_994031_F71E01B0)
Date: Mon, 08 Jul 2013 16:10:05 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 03/20] rt2x00: rt2800lib: add RFCSR
 register initialization for RT3593
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org> <1372664879-18474-4-git-send-email-juhosg@openwrt.org> <20130707141009.GC2073@localhost.localdomain>
In-Reply-To: <20130707141009.GC2073@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.07.07. 16:10 keltezéssel, Stanislaw Gruszka írta:
> On Mon, Jul 01, 2013 at 09:47:42AM +0200, Gabor Juhos wrote:
>> Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
>> driver.
>>
>> References:
>>   NICInitRT3593RFRegisters in chips/rt3593.c
>>   RT3593LoadRFNormalModeSetup in chips/rt3593.c
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
> 
>>  	case RT3390:
>>  		rt2800_init_rfcsr_3390(rt2x00dev);
>>  		break;
>> +	case RT3593:
>> +		rt2800_init_rfcsr_3593(rt2x00dev);
>> +		break;
>>  	case RT3572:
>>  		rt2800_init_rfcsr_3572(rt2x00dev);
>>  		break;
> 
> Nit: RT3572 should be before RT3593.

Fixed in v3. Thanks!

-Gabor
