Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2533 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab2BWUBA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 15:01:00 -0500
Message-ID: <4F469ADF.5040806@broadcom.com> (sfid-20120223_210103_362732_672207AC)
Date: Thu, 23 Feb 2012 12:00:31 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Kiss Robert" <kepten@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom brcm80211 monitor mode
References: <CAN+AqrXRuBQZ9Hvnd=sdauFdo1e5eYWBiyo8f2WFDy8EBLGvEQ@mail.gmail.com>
 <4F356004.9090409@broadcom.com>
 <CAN+AqrVLeJYQFLHqtmuhWQ_34x-6bG1uiYRJxj3zRvNJXknpPQ@mail.gmail.com>
In-Reply-To: <CAN+AqrVLeJYQFLHqtmuhWQ_34x-6bG1uiYRJxj3zRvNJXknpPQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2012 08:00 AM, Kiss Robert wrote:
> I have read somewhere that the Broadcom 4330 chipset on Samsung Galaxy
> S II cannot be put to monitor mode because of some hardware
> limitation. Is that true? Can someone confirm that?

Hi Robert,

It's a firmware limitation instead of hardware to be more precise. There 
is no firmware out there support monitor mode so the support can not be 
done by changing the host driver only.

Regards,
Franky

