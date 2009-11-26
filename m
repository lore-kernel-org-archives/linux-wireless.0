Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:34037 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760140AbZKZN5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 08:57:16 -0500
Received: by pwi3 with SMTP id 3so504667pwi.21
        for <linux-wireless@vger.kernel.org>; Thu, 26 Nov 2009 05:57:23 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 26 Nov 2009 21:57:22 +0800
Message-ID: <d82e647a0911260557l5cf33449pe41f8902b6889891@mail.gmail.com>
Subject: [question] ath9k: 11n monitor mode
From: Ming Lei <tom.leiming@gmail.com>
To: lrodriguez@atheros.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

I find the wireshark can only capture 11b/g packets but any 11n packets over
my ar9283 card, and I can confirm I have set HT40+ to make it work in 11n mode.

wireshark : 1.2.2
kernel       : 2.6.32-rc6

I don't know what is wrong with it, and could ath9k work well in monitor
mode of 11n?  or other reason?

Look forward to your reply.

Thanks,

-- 
Lei Ming
