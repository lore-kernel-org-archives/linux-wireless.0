Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44214 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1G3V1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 17:27:25 -0400
Received: by pzk37 with SMTP id 37so8612693pzk.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 14:27:24 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 30 Jul 2011 23:27:24 +0200
Message-ID: <CAC9WiBhiBBwoBR3p23wnO5LFSe0agRMkquvy9RjhmEs8NbYGfg@mail.gmail.com> (sfid-20110730_232728_112364_3315128B)
Subject: v3.0 wants a firmware for rt2870 but v2.6.39 needn't
From: Francis Moreau <francis.moro@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've just updated my kernel to 3.0 and now my wireless card using a
rt2870 chip doesn't work anymore.

It wants now a firmware rt2870.bin whereas this wasn't needed for older kernels.

Is this expected ? If so why the firmware is now mandatory whereas it
wasn't previously ?

Thanks
-- 
Francis
