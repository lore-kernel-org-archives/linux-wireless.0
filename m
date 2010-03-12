Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49340 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0CLGgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 01:36:44 -0500
Received: by bwz1 with SMTP id 1so763426bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 22:36:43 -0800 (PST)
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] wl1251: reduce eeprom read wait time
References: <1268322307-16694-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 12 Mar 2010 08:36:38 +0200
In-Reply-To: <1268322307-16694-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Thu\, 11 Mar 2010 17\:45\:07 +0200")
Message-ID: <87r5nqcah5.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> 4sec wait is way too pessimistic, TI driver uses 40ms here,
> and testing shows that is ebough, so let's also use that.
> While at it, add useful sounding comment from the TI driver.
>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
