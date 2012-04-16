Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46110 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab2DPTul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 15:50:41 -0400
Received: by wibhj6 with SMTP id hj6so9021968wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2012 12:50:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F469ADF.5040806@broadcom.com>
References: <CAN+AqrXRuBQZ9Hvnd=sdauFdo1e5eYWBiyo8f2WFDy8EBLGvEQ@mail.gmail.com>
 <4F356004.9090409@broadcom.com> <CAN+AqrVLeJYQFLHqtmuhWQ_34x-6bG1uiYRJxj3zRvNJXknpPQ@mail.gmail.com>
 <4F469ADF.5040806@broadcom.com>
From: Kiss Robert <kepten@gmail.com>
Date: Mon, 16 Apr 2012 21:50:20 +0200
Message-ID: <CAN+AqrXDTLVZqP_jdbWTm-=FFmj2RqY6sD+B-GiUR6OL_SU2xQ@mail.gmail.com> (sfid-20120416_215044_896813_D33EC3D3)
Subject: Re: Broadcom brcm80211 monitor mode
To: Franky Lin <frankyl@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Is there any hope in the near future for a brcm80211 firmware which
supports monitor mode? If I got it right, it is either Broadcom who
could release such a firmware or someone else who has infinite free
time to reverse engineer the blob firmware, right? Is there any
initiative for that? Maybe some progress on it? I ask it because I'd
like to contribute to such a project if it already exists.

Cheers,

Robert

On 23 February 2012 21:00, Franky Lin <frankyl@broadcom.com> wrote:
> On 02/23/2012 08:00 AM, Kiss Robert wrote:
>>
>> I have read somewhere that the Broadcom 4330 chipset on Samsung Galaxy
>> S II cannot be put to monitor mode because of some hardware
>> limitation. Is that true? Can someone confirm that?
>
>
> Hi Robert,
>
> It's a firmware limitation instead of hardware to be more precise. There is
> no firmware out there support monitor mode so the support can not be done by
> changing the host driver only.
>
> Regards,
> Franky
>
