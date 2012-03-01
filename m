Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3254 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759347Ab2CAOMo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 09:12:44 -0500
Message-ID: <4F4F83D2.8030101@broadcom.com> (sfid-20120301_151248_503566_08DEC6B0)
Date: Thu, 1 Mar 2012 15:12:34 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	"Rafal Milecki" <zajec5@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for
 SPROM storage
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
 <4F48D997.1060400@hauke-m.de> <4F4B571E.7040704@broadcom.com>
 <4F4D34FA.8070800@hauke-m.de>
In-Reply-To: <4F4D34FA.8070800@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2012 09:11 PM, Hauke Mehrtens wrote:
> On 02/27/2012 11:12 AM, Arend van Spriel wrote:
>> On 02/25/2012 01:52 PM, Hauke Mehrtens wrote:
>>> I will test you patch on my device soon and will report if something is
>>> wrong. If you are sending a non RFC patch in the next days I would
>>> rebase my patch onto yours. The code searching in the SoCs flash chip
>>> will be added to run if bcma_sprom_onchip_available() returns false.
>>
>> Appreciate any testing on SoCs. I think I will need some time to modify
>> brcmsmac so let your patch go first.
>
> The sprom part of my SoC is working with this patch on top of my sprom
> patches, but it uses the sprom from flash/nvram for both wifi devices
> (one integrated in the bCM4716 and the other a BCM43224 connected to the
> PCIe host controller of the BCM4716).
> For my BCM4716 bcma_sprom_ext_available() and
> bcma_sprom_onchip_available() are returning false and for the BCM43224
> bcma_sprom_ext_available() is returning false and
> bcma_sprom_onchip_offset() 0.

Thanks, Hauke

Did the BCM43224 come with the router. If so I am assuming the onchip is 
not used and the system relies on flash/nvram completely. I will inform 
whether my assumption is correct.

Gr. AvS

