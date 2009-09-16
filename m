Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx27.mail.ru ([94.100.176.41]:55484 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZIOXj1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 19:39:27 -0400
Date: Wed, 16 Sep 2009 03:46:11 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <792649359.20090916034611@mail.ru>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re[2]: cfg80211 and rfkill_backport question.
In-reply-To: <43e72e890909151614l9820e2y7031e09de11653@mail.gmail.com>
References: <174470396.20090916030952@mail.ru>
 <43e72e890909151614l9820e2y7031e09de11653@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luis,

Wednesday, September 16, 2009, 2:14:21 AM, Luis R. Rodriguez wrote:
> Ah nice, finally some tester on 2.6.25 :D

> So we never tested 2.6.25 on compat-wireless, I just got it to
> compile, that's all. So what I think you need is to make sure the
> symbols you are having issues with are either exported or included
> inline on a header. Can you check that?
Ok, could you be more specific? What should I do exactly? I'm not a
great kernel expert actually. :/

>   Luis


