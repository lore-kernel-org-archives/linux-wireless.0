Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:53436 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZKLQhI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 11:37:08 -0500
Date: Thu, 12 Nov 2009 17:37:09 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Please share info about power consumption characteristics of
 your USB adapter
Message-ID: <20091112163709.GA8357@sig21.net>
References: <200911112219.08814.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200911112219.08814.jkrzyszt@tis.icnet.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 11, 2009 at 10:19:07PM +0100, Janusz Krzysztofik wrote:
> 
> Please anyone owning one of adapters listed below: if the adapter is supported 
> by linux-wireless, please check for MaxPower with lsusb -v and give me the 
> result. I am looking for an adapter with MaxPower less than 300mA and would 
> rather not buy them all to learn they all do not fit :-).

> D-Link DWL-G122

Although I think you cannot rely on the numbers in the USB descriptor, FWIW:

  idVendor           0x07d1 D-Link System
  idProduct          0x3c03 DWL-G122 802.11g Adapter [ralink rt73]
  MaxPower              300mA

Johannes
