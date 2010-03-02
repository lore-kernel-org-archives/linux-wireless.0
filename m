Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:59189 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757310Ab0CBUbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 15:31:31 -0500
Message-ID: <4B8D75A1.9070603@gmail.com>
Date: Tue, 02 Mar 2010 21:31:29 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: fix rt2800pci compilation with SoC
References: <201003021634.50077.helmut.schaa@googlemail.com> <4B8D62CC.9040005@gmail.com> <20100302194533.GC16620@tuxdriver.com>
In-Reply-To: <20100302194533.GC16620@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/02/10 20:45, John W. Linville wrote:
> On Tue, Mar 02, 2010 at 08:11:08PM +0100, Gertjan van Wingerde wrote:
>> On 03/02/10 16:34, Helmut Schaa wrote:
>>> Compiling rt2800pci with CONFIG_RT2800PCI_SOC fails with "... rt2880pci.c:
>>> error: incompatible type for argument 2 of 'rt2x00soc_probe'".
>>>
>>> Fix this by using &rt2800pci_ops instead of rt2800pci_ops.
>>>
>>> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>>> ---
>>
>> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>
>> John, this is probably one that should go to wireless-2.6.
> 
> I agree, which is why I fixed the whitespace damage and applied it...grrr...

OK. Thanks for that.

---
Gertjan.

