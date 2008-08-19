Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:2137 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbYHSTIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 15:08:51 -0400
Received: by wa-out-1112.google.com with SMTP id j37so19822waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2008 12:08:51 -0700 (PDT)
Message-ID: <81b0412b0808191208y6bef9187nc57fa74c08a92d54@mail.gmail.com> (sfid-20080819_210907_999964_83DA7A62)
Date: Tue, 19 Aug 2008 21:08:50 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: rt2500pci: false alarm (was rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed)
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/8/19 Alex Riesen <raa.lkml@gmail.com>:
> 2008/8/19 Ivo van Doorn <ivdoorn@gmail.com>:
>>> The rt2500 driver in 2.6.27-rc3 (v2.6.27-rc3-552-g3c3a15a) constantly
>>> produces a lot of this messages in log (slowdown quite noticable):
>>>
>>>     kernel: phy0 -> rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
>
> It surely did, but I honestly don't remember what with. I'll try to bisect.
>

Ok, it _is_ the hardware. Precisely: it is a dusty box in a dark humid corner.
I reseated the card and suddenly everything started working.

I'm really sorry. The error description was actually a very good
hint at the problem.
