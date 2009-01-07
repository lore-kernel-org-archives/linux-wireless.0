Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:32683 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZAGOEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 09:04:08 -0500
Received: by yx-out-2324.google.com with SMTP id 8so2646172yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 06:04:07 -0800 (PST)
Message-ID: <e6236e5f0901070604w351e9199r9f2c2f8a44cd7a49@mail.gmail.com> (sfid-20090107_150413_635637_9280AB5E)
Date: Wed, 7 Jan 2009 15:04:07 +0100
From: "Rodrigo Fresneda" <fresneda@gmail.com>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: trouble with compat-old
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890901070440w63fbb06fy39e3bcb387f08d60@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e6236e5f0901060312h6946f9a1p49e299e723cb0190@mail.gmail.com>
	 <3ace41890901061536k7722b63h906962283ce9e4ad@mail.gmail.com>
	 <e6236e5f0901061740s20d817b1s2befb66cefbf72b0@mail.gmail.com>
	 <3ace41890901070440w63fbb06fy39e3bcb387f08d60@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, thanks again.


>
> yes and no... "y" sometimes means it assumes *your current kernel* has
> it built-in (i.e. = "ignore this option").

Unfortunately, didn't work out. But I am trying various configurations
to see if I get lucky.


> A shame you aren't using the latest compat-wireless.

Well, I am using the latest compat-wireless-*old*... and the only
reason is because I can't use a newer kernel. With 2.6.28 iwlagn works
like a charm, so why would I compile compat-wireless anyway?
Just to be clear about this, my kernel is the debian lenny stock
kernel 2.6.26-1-amd64


>
> Well, if you want to skip some modules, you just put comment it out,
> e.g. edit drivers/net/wireless/Makefile and put a "#" before any line
> that doesn't contain obj-$(CONFIG_IWL*
>

Thanks, now it goes much faster.
best wishes,
rodrigo.
