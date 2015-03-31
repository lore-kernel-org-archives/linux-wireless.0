Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2on0083.outbound.protection.outlook.com ([65.55.169.83]:34112
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753644AbbCaBO4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 21:14:56 -0400
Received: by igbqf9 with SMTP id qf9so4329554igb.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2015 17:40:43 -0700 (PDT)
MIME-Version: 1.0
From: Ashkan Parcham Kashani <ashkan.parchamkashani@mail.utoronto.ca>
Date: Mon, 30 Mar 2015 20:40:23 -0400
Message-ID: <CAPZAZS58=O1SHtnDeVrGLpvpBAg85-WQ_LNbsuqDbAu5GeQXBA@mail.gmail.com> (sfid-20150331_031459_793870_B8AB9873)
Subject: Re: Wireless Module: Carl9170 driver and firmware communication
To: <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear linux-wireless mailing list,

I'm working on a project where I need to communicate some additional
control information between the carl9170 driver and firmware. I am not
exactly sure where the best place to add this extra information would be. I
assumed that the DMA might work if I can extend it and reserve some
space for the controls. I only need a few bytes for the communication.

I also considered using device registers for this, but it's hard to
find documentation of which registers may be free to use.

It would be great to get some opinions on the best way to do this;
would you have any advice?

If the DMA is a possible way to go, how would I go about extending it?
To my understanding, the firmware sets the needed sizes, and the
driver allocates the DMA accorting to specification.

I'm also wondering how one would go about interrupting the firmware.
At times, the driver will need to interrupt the firmware, in which
case the firmware should stop transmitting any packets it is currently
transmitting.

Any help would be much appreciated. Thanks so much!
--
Ashkan Kashani
ashkan.parchamkashani@mail.utoronto.ca
4th year Engineering Science | Universtiy of Toronto
