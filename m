Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48057 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758389Ab2EJJun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:50:43 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: <linux-wireless@vger.kernel.org>, Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 00/78] 18xx chip support
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Date: Thu, 10 May 2012 12:50:42 +0300
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com> (Arik
	Nemtsov's message of "Thu, 10 May 2012 12:13:05 +0300")
Message-ID: <87ipg48ivh.fsf@purkki.adurom.net> (sfid-20120510_115050_190690_6FB35E2A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik Nemtsov <arik@wizery.com> writes:

> This series adds initial support for the 18xx chip family. The new
> module uses wlcore for functionality common with the 12xx family.

You do know that sending 78 patches in one patchset is very much
frowned upon? No sane person (outside of wl12xx) is going to review
all of these.

-- 
Kalle Valo
