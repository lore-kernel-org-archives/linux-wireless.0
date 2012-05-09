Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58989 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761223Ab2EIU7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 16:59:23 -0400
Received: by vbbff1 with SMTP id ff1so736345vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 13:59:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120509203730.GE17416@shaftnet.org>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6VjWxN6mP4E+7WoR=RZxmSU70GPbua77Vmw+z=JnnKcUg@mail.gmail.com>
	<CAMG6FYgcep04reRKFe6vjpW+THbCT=+FnJ_-eLrcgE7+3UJEfA@mail.gmail.com>
	<CABF+-6XSA8OOjwuQqM-iDKHVTriJ04BzfA-VN0MqVAiN_ZrsEA@mail.gmail.com>
	<20120509203730.GE17416@shaftnet.org>
Date: Wed, 9 May 2012 16:59:21 -0400
Message-ID: <CABF+-6VUMoueQTA5_JUEOjiya5eQY=bAzt=cnr23HJ=ssedQSw@mail.gmail.com> (sfid-20120509_225933_140371_16352EE2)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> For any given design with the cw1200, you're likely to need an SDD file
> specific to that design.  That's because the SDD file includes GPIO
> ...

Thanks for the further info on the SDD files Solomon.

As I mentioned in a previous post I am using the SG901-1091 module
from Sagrad.  The only SDD file I have tried that works is also from
Sagrad.  It makes perfect sense now that SDD files from other sources
do not work.

I still wonder why there is a PTA record in the SDD file if the
SG901-1091 module does not have Bluetooth.  Could this negatively
effect performance if it is trying to play nice with Bluetooth when
Bluetooth is not being used?


Kevin
