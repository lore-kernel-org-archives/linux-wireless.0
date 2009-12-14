Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34271 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbZLNKRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 05:17:21 -0500
Received: by bwz27 with SMTP id 27so1857910bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 02:17:19 -0800 (PST)
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/6] ath9k: Stop ANI when doing a reset
References: <19238.1557.201259.642604@gargle.gargle.HOWL>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 14 Dec 2009 12:17:16 +0200
In-Reply-To: <19238.1557.201259.642604@gargle.gargle.HOWL> (Sujith's message of "Mon\, 14 Dec 2009 15\:02\:05 +0530")
Message-ID: <87pr6hzwpf.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith <Sujith.Manoharan@atheros.com> writes:

> The MIB counters are disabled when doing a reset,
> disable ANI to handle this case.

The visible change to the user is good to explain. Was there packet
loss, did the kernel crash or what?

-- 
Kalle Valo
