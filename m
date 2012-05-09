Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43689 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab2EIS4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 14:56:35 -0400
Received: by vbbff1 with SMTP id ff1so609166vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 11:56:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMG6FYgcep04reRKFe6vjpW+THbCT=+FnJ_-eLrcgE7+3UJEfA@mail.gmail.com>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6VjWxN6mP4E+7WoR=RZxmSU70GPbua77Vmw+z=JnnKcUg@mail.gmail.com>
	<CAMG6FYgcep04reRKFe6vjpW+THbCT=+FnJ_-eLrcgE7+3UJEfA@mail.gmail.com>
Date: Wed, 9 May 2012 14:56:34 -0400
Message-ID: <CABF+-6XSA8OOjwuQqM-iDKHVTriJ04BzfA-VN0MqVAiN_ZrsEA@mail.gmail.com> (sfid-20120509_205644_764485_BB9DF7F8)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

Thanks for the information.

>> If a PTA element is found the code always sets priv->is_BT_Present =
>> true.  If I do not have Blue Tooth in my system should this still be
>> set?
>>
> Yes if you share antenna and use PTA (Bluetooth arbitrage) in your design.
> But in this case you should have SDD with PTA entry in.

My system does not have Bluetooth at all.  Will the existence of a PTA
record in my SDD file have any negative impact?

Can I just delete the PTA record?  (Easier said than done since it is
a binary file... but it can be done.)

Are there any other records in the SDD file that could cause problems?


Thanks,

Kevin
