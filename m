Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36939 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZLWN2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 08:28:54 -0500
Received: by ewy19 with SMTP id 19so6315200ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 05:28:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261573448.7304.0.camel@johannes.local>
References: <e92712b70912170610y74eb6ae8ifd8db347cc608808@mail.gmail.com>
	 <1261061645.10356.114.camel@johannes.local>
	 <e92712b70912230428s7caee5eag6943a8eb6a8b7a78@mail.gmail.com>
	 <1261571890.3512.0.camel@johannes.local>
	 <e92712b70912230454y3da0f49ame84957a136b674bf@mail.gmail.com>
	 <1261573448.7304.0.camel@johannes.local>
Date: Wed, 23 Dec 2009 15:28:53 +0200
Message-ID: <e92712b70912230528r6cdd8f95j4df9db9ff6b02e66@mail.gmail.com>
Subject: Re: Backoff algorithm
From: Andrey Lukyanenko <laser.ru@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Well both b43 and ar9170 have open firmware. I don't know how to solve
> your problem, and I'm not interested in it either -- I'm just trying to
> give you pointers that may help. However, if you only have the hw you
> do, then I don't know at all.

Yes, your are right. Acctually I already checked the source code of ar9170-fw
(I forgot about it, as I did not find what I was interested in it) and b43_4.5.
The second was a part of OpenFWWF project. The backoff code in b43 is
in few asm functions (right now easiest for me way to change, only need to
buy hw).

Thanks a lot, I am really appreciate your help.


-- 
Best regards,
Andrey Lukyanenko.
