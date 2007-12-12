Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34490 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbXLLVFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 16:05:12 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: Fix for broken transmission
Date: Wed, 12 Dec 2007 22:03:22 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200712121950.12079.mb@bu3sch.de>
In-Reply-To: <200712121950.12079.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712122203.22491.mb@bu3sch.de> (sfid-20071212_210519_690253_7E9AB324)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 December 2007 19:50:11 Michael Buesch wrote:
> This patch fixes the transmission problems introduced by
> commit f04b3787bbce4567e28069a9ec97dcd804626ac7
> 
> I'm not sure if the dummy read is really required.
> The old code does it. I think it can't hurt and can possibly
> fix some write posting problems (hardware bugs or whatever. Who knows).
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 

Ah, crap. This was the wrong one. Give me a second and I will send the correct one.


-- 
Greetings Michael.
