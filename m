Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3009 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab2FGTVs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 15:21:48 -0400
Message-ID: <4FD0FF3D.2060805@broadcom.com> (sfid-20120607_212151_357780_B4DF5565)
Date: Thu, 7 Jun 2012 21:21:33 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/18] brcmsmac: extend xmtfifo_sz array
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-15-git-send-email-hauke@hauke-m.de>
 <4FCF2FD4.6010103@broadcom.com> <4FD0AD96.1050500@hauke-m.de>
In-Reply-To: <4FD0AD96.1050500@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2012 03:33 PM, Hauke Mehrtens wrote:
> On 06/06/2012 12:24 PM, Arend van Spriel wrote:
>> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>>> The xmtfifo_sz array contains the queue sizes for the different chip
>>> revs. This array missed the sizes for the core rev 17 and 28. This
>>
>> Should probably use core revs instead of chip revs and I think we are
>> talking about the 80211 core rev here.
> Yes I will change this comment.
> 
> Are there any devices with the same phy type using different fifo sizes?
> If this is not the case I think it is better to do this based on the phy
> type.

I dived into this and basically there is no correlation to the phy type.
There are chips with same 80211 core rev and different phy type as there
are chips with different 80211 core rev and the same phy type.

Gr. AvS


