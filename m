Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:46691 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbZIOXtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 19:49:20 -0400
Received: by iwn8 with SMTP id 8so2008569iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2009 16:49:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <792649359.20090916034611@mail.ru>
References: <174470396.20090916030952@mail.ru> <43e72e890909151614l9820e2y7031e09de11653@mail.gmail.com>
	<792649359.20090916034611@mail.ru>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 15 Sep 2009 16:49:04 -0700
Message-ID: <43e72e890909151649x66321b6emdc2977473e22872a@mail.gmail.com>
Subject: Re: Re[2]: cfg80211 and rfkill_backport question.
To: Nikolai ZHUBR <zhubr@mail.ru>
Cc: linux-wireless@vger.kernel.org,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 15, 2009 at 5:46 PM, Nikolai ZHUBR <zhubr@mail.ru> wrote:
> Hello Luis,
>
> Wednesday, September 16, 2009, 2:14:21 AM, Luis R. Rodriguez wrote:
>> Ah nice, finally some tester on 2.6.25 :D
>
>> So we never tested 2.6.25 on compat-wireless, I just got it to
>> compile, that's all. So what I think you need is to make sure the
>> symbols you are having issues with are either exported or included
>> inline on a header. Can you check that?
> Ok, could you be more specific? What should I do exactly? I'm not a
> great kernel expert actually. :/

Check if the symbols you had issues with were indeed exported via
EXPORT_SYMBOL() on the compat code (compat/*.c) or if whether they
were defined via a header as an inline (compat/*.h).

  Luis
