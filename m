Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn1bon0061.outbound.protection.outlook.com ([157.56.111.61]:59072
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752119AbaKZTYb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 14:24:31 -0500
Received: by mail-ie0-f179.google.com with SMTP id rp18so3261251iec.38
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 11:24:24 -0800 (PST)
MIME-Version: 1.0
From: Ashkan Parcham Kashani <ashkan.parchamkashani@mail.utoronto.ca>
Date: Wed, 26 Nov 2014 14:24:03 -0500
Message-ID: <CAPZAZS5EiYg9DPRjJjKmjm680Xh5ycmn9fZw9f2SuJ_TxnYemQ@mail.gmail.com> (sfid-20141126_202434_108146_8D1C33A5)
Subject: Wireless Module: Carl9170 driver and firmware communication
To: <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm working on a project where I need to communicate some additional
control information between the carl9170 driver and firmware. I am not
exactly sure where the best place to add this information would be. I
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
