Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:59629 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864AbaIRUua (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 16:50:30 -0400
Message-ID: <541B4591.3010208@hauke-m.de> (sfid-20140918_225033_954494_DB2DA829)
Date: Thu, 18 Sep 2014 22:50:25 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/2] bcma: register bcma as device tree driver
References: <1410904582-6519-1-git-send-email-hauke@hauke-m.de> <CACna6rzGa6wiKTrXbtUSGekRNq7gUkC0kyu4RQ_p4fG0Hd+DjQ@mail.gmail.com> <541AA904.1070002@broadcom.com>
In-Reply-To: <541AA904.1070002@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2014 11:42 AM, Arend van Spriel wrote:
> On 09/17/14 17:10, Rafał Miłecki wrote:
>> On 16 September 2014 23:56, Hauke Mehrtens<hauke@hauke-m.de>  wrote:
>>> This driver is used by the bcm53xx ARM SoC code. Now it is possible to
>>> give the address of the chipcommon core in device tree and bcma will
>>> search for all the other cores.
>>
>> Did you get any answer from Arend about detecting IRQs?
>>
>> If not:
>> Arend: how much time it make take you to get an answer?
> 
> I already discussed this with our chip architect. There is a chip design
> rule that core index corresponds to the irq number. This at least is
> true for the bcm43xx devices, but unsure about others. So that option
> does not seem to fit. That leaves the OOB_ROUTER core I mentioned
> earlier, but it is a chip designers nightmare as they told me. Did not
> sound encouraging enough to start digging in there to obtain the
> information.

Thanks for asking around.

I will go with specifying the IRQs in device tree then.

Hauke
