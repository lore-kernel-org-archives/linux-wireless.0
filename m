Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:60877 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3JGH5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 03:57:07 -0400
Received: by mail-ve0-f175.google.com with SMTP id jy13so3552701veb.34
        for <linux-wireless@vger.kernel.org>; Mon, 07 Oct 2013 00:57:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381132198.13586.1.camel@jlt4.sipsolutions.net>
References: <1380234508-3121-1-git-send-email-k.eugene.e@gmail.com>
	<20131004234514.GA11128@garbanzo.do-not-panic.com>
	<1381132198.13586.1.camel@jlt4.sipsolutions.net>
Date: Mon, 7 Oct 2013 08:57:06 +0100
Message-ID: <CAFSJ42agnFAy1ShGvQERz4pHKJ02ByZAZGWg-m9TGM8am8Lewg@mail.gmail.com> (sfid-20131007_095712_157898_8F41EBBE)
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org, wcn36xx@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanx Johannes for advice. Will try it as well.

2013/10/7 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2013-10-04 at 16:45 -0700, Luis R. Rodriguez wrote:
>
>> Nice! I test compiled with sparse enabled and got this:
>
> Could also consider running smatch.
>
> johannes
>



-- 
Best regards,
Eugene
