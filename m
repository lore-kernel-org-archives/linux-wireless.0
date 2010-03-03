Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44114 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab0CCRIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 12:08:52 -0500
Received: by gyd8 with SMTP id 8so145249gyd.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 09:08:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003031804.54121.helmut.schaa@googlemail.com>
References: <201003031742.55842.helmut.schaa@googlemail.com>
	 <14add3d11003030850j2c16a92dsfad2a4a43c4d126c@mail.gmail.com>
	 <201003031804.54121.helmut.schaa@googlemail.com>
Date: Wed, 3 Mar 2010 18:08:51 +0100
Message-ID: <14add3d11003030908v620dc63ci4712373a77da275a@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Export rt2x00soc_probe from rt2x00soc
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 3, 2010 at 6:04 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Mittwoch 03 März 2010 schrieb Gertjan van Wingerde:
>> Thanks for doing this. I couldn't test these configurations as I am
>> lacking SoC devices.
>
> No problem, I'm just trying to get the driver up on one of these SoC devices.
> Not sure how far I'll get :)
>

All I can say is to please keep us informed on your progress. It is
the first time I'm hearing someone actually working with a SoC device.

Can you share some information on what device you have, and what
Ralink chipset is on this device (the detection messages in dmesg for
this device would be interesting).

---
Gertjan.
