Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52518 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab1INJjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:39:00 -0400
Received: by fxe4 with SMTP id 4so1579259fxe.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 02:38:58 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Louis" <louis.m@gmx.net>
Subject: Re: AR9170 chipset details
Date: Wed, 14 Sep 2011 11:38:55 +0200
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <20110913080246.184260@gmx.net>
In-Reply-To: <20110913080246.184260@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201109141138.55437.chunkeey@googlemail.com> (sfid-20110914_113904_827872_ABF8D259)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, September 13, 2011 10:02:46 AM Louis wrote:
> I need a detailed description of the Atheros AR9170 chipset.
Well, there's me and Stephen. He usually handels the stuff thats
not in the documents but unfortunately I don't have his new
qualcomm email... Luis, do you have it?

> Does someone know if there is a reference guide or a detailed datasheet
> with the chip`s functions and register descriptions available somewhere. 
You can learn a lot from the original otus driver and firmware
sources. In fact thats the only ressources I had during most of
the development. I have my doubts about the docs. They are not
of much help anyway since they sort of divert from the actual
silicon.

> On which information base has the carl9170 driver been developed? 
Original otus driver and the firmware... Unfortunately, most of
the stuff was hosted on kernel.org which is currently unavailable.
[I do have copies, but I don't carry them around so I can't provide
a backup atm.]

Regards,
	Chr
