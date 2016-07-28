Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:61833 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245AbcG1QAv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 12:00:51 -0400
Subject: Re: staging: wilc1000: Reduce scope for a few variables in
 mac_ioctl()
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
References: <1c4cac35-dded-ea88-45aa-3f8ac098289d@gmx.de>
 <d8d9729c-6d65-a901-1b29-c0b031e143d2@users.sourceforge.net>
 <trinity-308db848-f204-4ebe-9336-484347ffbf37-1469706334519@3capp-gmx-bs72>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Steve Caldwell <Steve.Caldwell@microchip.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <c178cb06-a4b2-0a43-1de1-61bd67816deb@users.sourceforge.net> (sfid-20160728_180114_580608_E6994CDD)
Date: Thu, 28 Jul 2016 18:00:24 +0200
MIME-Version: 1.0
In-Reply-To: <trinity-308db848-f204-4ebe-9336-484347ffbf37-1469706334519@3capp-gmx-bs72>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Which circumstances do "not any sense at all" imply? 

Should the expression 'strlen("RSSI")' be passed for the parameter 'length' instead?


> I suggest to fix this since it is indeed a bug,

We can agree that this function implementation was broken for a while there.


> instead of doing "micro optimizations" - which is the last thing that code in the staging area 
> needs (as IIRC you have already been told by others, including the staging maintainer).

The acceptance might grow a bit more for such software fine-tuning
(like refactoring around variable usage).

Regards,
Markus
