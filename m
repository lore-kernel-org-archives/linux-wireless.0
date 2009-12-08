Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59225 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZLHKTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 05:19:01 -0500
Received: by yxe17 with SMTP id 17so4775680yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 02:19:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091208095755.GT18989@one.firstfloor.org>
References: <20091204233202.GA13658@basil.fritz.box> <4B1BB44E.90706@gmail.com>
	 <200912080006.28892.s.L-H@gmx.de>
	 <20091208095755.GT18989@one.firstfloor.org>
Date: Tue, 8 Dec 2009 11:19:07 +0100
Message-ID: <14add3d10912080219u17c65cbemf6d56290a8f12efd@mail.gmail.com>
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors in
	2.6.32
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	linux-wireless@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 8, 2009 at 10:57 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> This patch doesn't seem to change this particular issue, disabling
>> powersaving however makes rt62pci work again.
>
> Yes confirmed here. Haven't seen it in a day or so with disabled power
> saving.
>
> However I haven't tried the patch with power saving enabled.

OK.
I think Stefan said that the patch didn't help for this issue.

However, I've got an other hunch (based on the Ralink driver). Maybe
we shouldn't go to sleep when still TX entries are present. I'll cook
up a patch tonight.

---
Gertjan.
