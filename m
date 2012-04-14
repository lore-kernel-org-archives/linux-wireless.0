Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57793 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955Ab2DNUUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 16:20:37 -0400
Message-ID: <4F89DC0B.20106@hauke-m.de> (sfid-20120414_222040_747948_2957DBE1)
Date: Sat, 14 Apr 2012 22:20:27 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: brcmsmac on BCM47XX SoCs
References: <4F7F71A2.40105@hauke-m.de> <4F815181.6030007@broadcom.com>
In-Reply-To: <4F815181.6030007@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2012 10:51 AM, Arend van Spriel wrote:
> On 04/06/2012 11:43 PM, Hauke Mehrtens wrote:
>> Are there any devices with a ccrev<  20 supported by brcmsmac, the
>> lowest version I saw was 31 and there are some conditions in brcmsmac
>> for<  6,<  10 and<  20?
> 
> brcmsmac is targetted for bcm4313, bcm43224, and bcm43225 so the lowest
> is ccrev 32. The bcm4718 seems to have ccrev 31.
> 

Now I am at the pci core rev. Are there any bcma/ai based devices with a
PCI not PCIE core on the chip? The PCIE cores of my devices are rev 14
(BCM4718) and 15 (BCM43224) are there any devices with a bus supported
by bcma available with a revision less than 14? In brcmsmac is lots of
code to do something different on devices with such PCI(E) core revs.

Hauke
