Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:39747 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbZKJPsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 10:48:06 -0500
Received: by fxm21 with SMTP id 21so150866fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 07:48:10 -0800 (PST)
MIME-Version: 1.0
From: Luca Niccoli <lultimouomo@gmail.com>
Date: Tue, 10 Nov 2009 16:47:50 +0100
Message-ID: <4e9568870911100747o6088ca86lf168849e6a42b91d@mail.gmail.com>
Subject: Please backport [PATCH] rtl8187: Fix kernel oops when device is
	removed when LEDS enabled (Bugzilla #14539)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm running 2.6.31 (from debian source) and I experienced hard freezes
on removing the module or disconnecting the USB card.
The patch at [1] seems to have fixed the problem, so it would be nice
if it could be included in the 2.6.31 branch.
Note that I was not experiencing the freezes with the distribution
kernel, just with a self compiled one (without source modifications
though, only config).
Cheers,

Luca

(For further info please Cc: me)

[1]
http://marc.info/?l=linux-wireless&m=125731443329754&w=2
