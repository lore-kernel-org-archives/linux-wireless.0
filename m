Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50325 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab3FPQZm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jun 2013 12:25:42 -0400
Received: from mailout-de.gmx.net ([10.1.76.12]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LcE27-1U4hks3zNt-00jW8p for
 <linux-wireless@vger.kernel.org>; Sun, 16 Jun 2013 18:25:40 +0200
Message-ID: <51BDE700.6080503@rempel-privat.de> (sfid-20130616_182600_445109_8C7DDD27)
Date: Sun, 16 Jun 2013 18:25:36 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: Add custom parameters for CUS198
References: <1371144086-10150-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1371144086-10150-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 13.06.2013 19:21, schrieb Sujith Manoharan:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> CUS198 is a card based on AR9485. There are differences
> between the base reference design HB125 and CUS198.
> Identify such cards based on the PCI subsystem IDs and
> set HW parameters appropriately.
>
> Addresses this bug - https://bugzilla.kernel.org/show_bug.cgi?id=49201

Thanks!!!

this patch made my day. I newer thought this adapter can provide good 
performance. Now, I can even see WiFi of my neighbour.


-- 
Regards,
Oleksij
