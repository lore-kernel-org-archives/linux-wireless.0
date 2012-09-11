Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3941 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab2IKStO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 14:49:14 -0400
Message-ID: <504F87A2.6050905@broadcom.com> (sfid-20120911_204918_434175_BEB91C59)
Date: Tue, 11 Sep 2012 20:49:06 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Florian Fainelli" <florian@openwrt.org>
Subject: Re: [PATCH 00/10] brcmfmac: transmit flow control and e-scan
 support
References: <1347283018-24223-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1347283018-24223-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2012 03:16 PM, Arend van Spriel wrote:
> This series contains transmit flow control handling when the brcmfmac driver
> has no resources to transfer packets over the host interface. This improves
> throughput number for TCP. The other feature in this series is event based
> scanning in which firmware sends an event per BSS.
>
> The other changes in this series are small fixes.
>
> This series is for the v3.7 kernel and applies to the wireless-next tree.

Hi John,

Please drop this series. I will resent it to address the comments made 
by Florian.

Gr. AvS

