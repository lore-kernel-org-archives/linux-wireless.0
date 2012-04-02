Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4192 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab2DBVkq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 17:40:46 -0400
Message-ID: <4F7A1CC8.4020006@broadcom.com> (sfid-20120402_234049_499488_4DFF8927)
Date: Mon, 2 Apr 2012 14:40:24 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Kiran Karra" <kiran.karra@gmail.com>
cc: "linux wireless" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4329 chipset -- open80211s
References: <CAAaUcVyTk7zRs4XACXa_Sw_n6qgcF_7b2Mf_dNhEMsiwgGa_QA@mail.gmail.com>
In-Reply-To: <CAAaUcVyTk7zRs4XACXa_Sw_n6qgcF_7b2Mf_dNhEMsiwgGa_QA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kiran,

On 03/31/2012 12:18 PM, Kiran Karra wrote:
> Hi All,
> I would like to know if I can use open80211s with the BCM4329 chipset?
>   From the research I've done, the BCM4329 is a FullMAC device, not a
> SoftMAC device.  The open-source linux driver that can work with the
> BCM4329 chipset is the brcmfmac.  Therefore, it does not use the
> mac80211 framework.  The brcmfmac driver is integrated with cfg80211.
> Since open80211s is based off the mac80211 stack, does this mean
> open80211s can never be used with brcmfmac?  Is it possible to
> interface the open80211s code directly with cfg80211?  Would the
> cfg80211 api provide all the necessary callbacks in order to acheive
> mesh functionality?  If this is possible, does anyone have an idea of
> how much time this effort would require?

The current implementation of support for 4329 is using the chipset to 
handle all 80211 stuff. The packet passed between host and the dongle 
chipset is Ethernet packet (802.3). Currently we don't have any plan to 
add mesh mode support in firmware.

Thanks,
-Franky


