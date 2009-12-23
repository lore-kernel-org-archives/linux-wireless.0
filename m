Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62337 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbZLWPKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 10:10:37 -0500
Received: by ewy19 with SMTP id 19so6418865ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 07:10:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091223145211.GB2811@tuxdriver.com>
References: <b170af450912230401l7a27b981o42cdbc96e5a16b57@mail.gmail.com>
	 <20091223145211.GB2811@tuxdriver.com>
Date: Wed, 23 Dec 2009 16:10:35 +0100
Message-ID: <b170af450912230710t77cc614j25f058b64c4ce51@mail.gmail.com>
Subject: Re: [PATCH][resend with linux-wireless] b43: N-PHY: clean table init,
	check PHY rev
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 23 grudnia 2009 15:52 użytkownik John W. Linville
<linville@tuxdriver.com> napisał:
> On Wed, Dec 23, 2009 at 01:01:58PM +0100, Rafał Miłecki wrote:
>> It's just compilation-tested as I don't own N-PHY device yet (should receive
>> one for Christmas). Of course I enabled N-PHY in Kconfig.
>>
>> I already sent this to bcm43xx-dev but didn't get any review. Michael told
>> me to send it to you John and to linux-wireless. Is there anyone how could
>> review/ack my patch?
>>
>>
>> From 6800722c2fda0e302d7c759a5f2a993503b6581a Mon Sep 17 00:00:00 2001
>> From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
>> Date: Tue, 22 Dec 2009 02:27:21 +0100
>> Subject: [PATCH] b43: N-PHY: clean table init, check PHY rev
>> MIME-Version: 1.0
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 8bit
>>
>> Move table init to tables_nphy.c, detect newer PHY which use different init
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> drivers/net/wireless/b43/phy_n.c       |   43 ++++------------------------
>> drivers/net/wireless/b43/tables_nphy.c |   48
>> ++++++++++++++++++++++++++++++++
>> drivers/net/wireless/b43/tables_nphy.h |    4 ++-
>> 3 files changed, 58 insertions(+), 37 deletions(-)
>
> Well, the patch is fairly clearly whitespace-damaged.  Perhaps that
> is a product of how you forwarded it to linux-wireless?

I created a new mail, no forwarding. I guess this is GMail issue,
afraid I'll have to install some native mail client.


> Other than that, it looks like you are mostly just moving code around.
> That's fine, but there doesn't seem to be a lot of point in it
> unless the rev 3+ stuff is coming soon?  It probably doesn't harm
> much either way...

I believe I've moved code to it's correct place. That is what file
name /says/ (tables_nphy.c) and what is done for LP-PHY. I don't know
yet what revision will be my device. But at least for training I want
to implement b43_nphy_rev3plus_table_init(...) (next one patch maybe).

If you decide to agree to commit this patch and you want to me resend
this with correct white spaces, please ping me about. For future mails
I'll use some native mailer.

-- 
Rafał
