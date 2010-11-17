Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55929 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935676Ab0KQXIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 18:08:34 -0500
Received: by qyk12 with SMTP id 12so6955878qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 15:08:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201011180112.18813.mgd@qata.de>
References: <1290019933-9924-1-git-send-email-zajec5@gmail.com>
	<201011180112.18813.mgd@qata.de>
Date: Thu, 18 Nov 2010 00:08:33 +0100
Message-ID: <AANLkTim+uzZWdEVhF0KqHuCQ93bsKp=2v4BB3uWXNyxE@mail.gmail.com>
Subject: Re: [PATCH] ssb: drop BCM4328 hack for SPROM revision
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Gerdau <mgd@qata.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 18 listopada 2010 01:12 użytkownik Michael Gerdau <mgd@qata.de> napisał:
>> This hacks leads to incorrect SPROM parsing for me and reading for
>> example MAC as: 00:00:00:54:00:00. Michael G. who introduced this
>> confirmed it is not needed anymore.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> Michael: I guess I could add your Tested-by. Is that right?
>
> That ist right. I suppose the correct entry would be
> Tested-by: Michael Gerdau <mgd@qata.de>

John: can you add this, please?

-- 
Rafał
