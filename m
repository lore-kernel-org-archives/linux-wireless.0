Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4154 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab2DPVIm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 17:08:42 -0400
Message-ID: <4F8C8A52.1070908@broadcom.com> (sfid-20120416_230846_060693_0FBC3DB7)
Date: Mon, 16 Apr 2012 14:08:34 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Kiss Robert" <kepten@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom brcm80211 monitor mode
References: <CAN+AqrXRuBQZ9Hvnd=sdauFdo1e5eYWBiyo8f2WFDy8EBLGvEQ@mail.gmail.com>
 <4F356004.9090409@broadcom.com>
 <CAN+AqrVLeJYQFLHqtmuhWQ_34x-6bG1uiYRJxj3zRvNJXknpPQ@mail.gmail.com>
 <4F469ADF.5040806@broadcom.com>
 <CAN+AqrXDTLVZqP_jdbWTm-=FFmj2RqY6sD+B-GiUR6OL_SU2xQ@mail.gmail.com>
In-Reply-To: <CAN+AqrXDTLVZqP_jdbWTm-=FFmj2RqY6sD+B-GiUR6OL_SU2xQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 12:50 PM, Kiss Robert wrote:
> Hi,
>
> Is there any hope in the near future for a brcm80211 firmware which
> supports monitor mode? If I got it right, it is either Broadcom who
> could release such a firmware or someone else who has infinite free
> time to reverse engineer the blob firmware, right? Is there any
> initiative for that? Maybe some progress on it? I ask it because I'd
> like to contribute to such a project if it already exists.

There is no plan for adding monitor mode support since it's not 
requested by any products. And it's impossible to release the firmware 
source code at the moment. I am not aware of any reverse engineering 
project for Broadcom fullmac dongle. However, I do plan to work on the 
monitor mode support on the firmware for SDIO dongle as a leisure 
project although I don't have a schedule for it. I will announce it on 
the mail list when it's ready. Stay tuned :)

Regards,
-Franky

