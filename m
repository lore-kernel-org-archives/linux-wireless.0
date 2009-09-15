Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:58730 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZIOXOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 19:14:37 -0400
Received: by iwn8 with SMTP id 8so1998030iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2009 16:14:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <174470396.20090916030952@mail.ru>
References: <174470396.20090916030952@mail.ru>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 15 Sep 2009 16:14:21 -0700
Message-ID: <43e72e890909151614l9820e2y7031e09de11653@mail.gmail.com>
Subject: Re: cfg80211 and rfkill_backport question.
To: Nikolai ZHUBR <zhubr@mail.ru>
Cc: linux-wireless@vger.kernel.org,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 15, 2009 at 5:09 PM, Nikolai ZHUBR <zhubr@mail.ru> wrote:
> Hello people,
>
> I'm trying to use compat-wireless-2009-09-14 for kernel 2.6.25.20.

Ah nice, finally some tester on 2.6.25 :D

So we never tested 2.6.25 on compat-wireless, I just got it to
compile, that's all. So what I think you need is to make sure the
symbols you are having issues with are either exported or included
inline on a header. Can you check that?

  Luis
