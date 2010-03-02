Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:62987 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426Ab0CBTLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 14:11:10 -0500
Message-ID: <4B8D62CC.9040005@gmail.com>
Date: Tue, 02 Mar 2010 20:11:08 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: fix rt2800pci compilation with SoC
References: <201003021634.50077.helmut.schaa@googlemail.com>
In-Reply-To: <201003021634.50077.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/02/10 16:34, Helmut Schaa wrote:
> Compiling rt2800pci with CONFIG_RT2800PCI_SOC fails with "... rt2880pci.c:
> error: incompatible type for argument 2 of 'rt2x00soc_probe'".
> 
> Fix this by using &rt2800pci_ops instead of rt2800pci_ops.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

John, this is probably one that should go to wireless-2.6.

---
Gertjan
