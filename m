Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34149 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbZLQOK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2009 09:10:26 -0500
Received: by ewy19 with SMTP id 19so440090ewy.21
        for <linux-wireless@vger.kernel.org>; Thu, 17 Dec 2009 06:10:24 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 17 Dec 2009 16:10:24 +0200
Message-ID: <e92712b70912170610y74eb6ae8ifd8db347cc608808@mail.gmail.com>
Subject: Backoff algorithm
From: Andrey Lukyanenko <laser.ru@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Everyone,

I wanted to find implementation of backoff protocols for different platforms.
I tried to find it in various open-source drivers in linux-sources, madwifi and
stlc45xx. Everywhere I could only find some initialization of CWmax, CWmin, ...
but not the actual algorithm (something like, cw = min(cw<<1 + 1, cwmax) ),
except ath_rate sample/mistrel where the operation is used for "best
rate measurement"
as I understood.
Am I correct to assume that the protocol is implemented in firmwhere and there
is no open source driver which I could use to "play" directly with it?

Thanks in advance.

-- 
Best regards,
Andrey Lukyanenko.
