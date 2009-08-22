Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:50822 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZHVO26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 10:28:58 -0400
Received: by pxi34 with SMTP id 34so4504595pxi.4
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2009 07:28:59 -0700 (PDT)
Message-ID: <4A90005B.3030101@lwfinger.net>
Date: Sat, 22 Aug 2009 09:27:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: feng tian <feng.of.tian@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Abour linux driver supports BCM4325
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com>	 <4A8E8F59.9050706@lwfinger.net>	 <1250858409.5137.2.camel@johannes.local> <f42a38140908212242h1ce0339fw1243dbacf54000ab@mail.gmail.com>
In-Reply-To: <f42a38140908212242h1ce0339fw1243dbacf54000ab@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

feng tian wrote:
> Instead of waiting for the codes, we decide to do someting on
> supporting the BCM 4325 running in linux via SDIO.
> The linux wireless dirver supports another chip (marvel 8686) with
> SDIO interface, the sources codes locate in
> drivers/net/wireless/libertas.
> We are wondering to develop the BCM4325 driver in the reference to the
> marvel 8686 SDIO driver.
> Please give comments on this, thanks.

The SDIO routines might be transferable; however, the radio and PHY
code will be completely different.
