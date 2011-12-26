Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:49246 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab1LZP3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 10:29:25 -0500
Date: Mon, 26 Dec 2011 16:29:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b43: support new RX header, noticed to be used in 598.314+
 fw
Message-ID: <alpine.DEB.2.00.1112261608140.12108@axis700.grange> (sfid-20111226_162930_350908_8261104C)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Sorry for "simulating" a reply - I'm not subscribed to linux-wireless, so,
cannot (easily) reply.
   
The commit in subject line

commit 17030f48e31adde5b043741c91ba143f5f7db0fd
From: Rafa³ Mi³ecki <zajec5@gmail.com>
Date: Thu, 11 Aug 2011 17:16:27 +0200
Subject: [PATCH] b43: support new RX header, noticed to be used in 598.314+ fw

breaks my b43 SDIO card in 3.2-ish kernels. Given the approaching 
3.2-final release, would be nice to have it fixed before that. The card 
I've got is marked with some "SD-Link11g" from some "C-guys, Inc." from 
Taiwan:-) Using firmware version 410.31754. Do I really _have_ to update 
or is the driver supposed to handle "all" firmware versions, or at least 
not drop ones, it used to support before?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
