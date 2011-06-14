Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35230 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab1FNOLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 10:11:37 -0400
Received: by ewy4 with SMTP id 4so2037555ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 07:11:36 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: ShawnG <swggator4@gmail.com>
Subject: Re: DWA-160
Date: Tue, 14 Jun 2011 16:12:10 +0200
Cc: linux-wireless@vger.kernel.org
References: <BANLkTim0mV230taAmbTm_Rm0wfPBGAznhw@mail.gmail.com>
In-Reply-To: <BANLkTim0mV230taAmbTm_Rm0wfPBGAznhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201106141612.11117.chunkeey@googlemail.com> (sfid-20110614_161142_204079_D6C5AD9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 June 2011 15:45:28 ShawnG wrote:
> I have been seeing strange stuff with the DWA-160 ver A2. Can you recommend
> another USB Wifi stick to replace ?
Depends. I've to say that I'm slightly biased towards Atheros products.
Although, Ralink and Realtek have interesting products as well.

So, if you don't need 5GHz then I would go with a ath9k_htc device
like: TL-WN821N *V3* [Note: V3 is important, because previous
versions are based on AR9170, however they stopped making them
some time ago [6-7 months?], so it should be safe to assume they've
disappeared from retail stores by now.] 

if you do need 5GHz, then it might be a good idea to ask:
George Nychis <gnychis@cmu.edu>

He has done some testing with several 5GHz capable ath9k_htc devices
from different vendors and might know which are well suited.

Regards,
	Chr
