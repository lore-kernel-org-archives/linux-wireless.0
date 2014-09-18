Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:59038 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbaIRJmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 05:42:31 -0400
Message-ID: <541AA904.1070002@broadcom.com> (sfid-20140918_114237_324820_12133F12)
Date: Thu, 18 Sep 2014 11:42:28 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] bcma: register bcma as device tree driver
References: <1410904582-6519-1-git-send-email-hauke@hauke-m.de> <CACna6rzGa6wiKTrXbtUSGekRNq7gUkC0kyu4RQ_p4fG0Hd+DjQ@mail.gmail.com>
In-Reply-To: <CACna6rzGa6wiKTrXbtUSGekRNq7gUkC0kyu4RQ_p4fG0Hd+DjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/17/14 17:10, Rafał Miłecki wrote:
> On 16 September 2014 23:56, Hauke Mehrtens<hauke@hauke-m.de>  wrote:
>> This driver is used by the bcm53xx ARM SoC code. Now it is possible to
>> give the address of the chipcommon core in device tree and bcma will
>> search for all the other cores.
>
> Did you get any answer from Arend about detecting IRQs?
>
> If not:
> Arend: how much time it make take you to get an answer?

I already discussed this with our chip architect. There is a chip design 
rule that core index corresponds to the irq number. This at least is 
true for the bcm43xx devices, but unsure about others. So that option 
does not seem to fit. That leaves the OOB_ROUTER core I mentioned 
earlier, but it is a chip designers nightmare as they told me. Did not 
sound encouraging enough to start digging in there to obtain the 
information.

Regards,
Arend
