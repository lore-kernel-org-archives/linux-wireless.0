Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50643 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab0IQDCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 23:02:47 -0400
Received: by iwn5 with SMTP id 5so1579511iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 20:02:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009171148.39953.br1@einfach.org>
References: <201009171148.39953.br1@einfach.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 16 Sep 2010 20:02:26 -0700
Message-ID: <AANLkTinYo5qgXvSnQSHpLbhhBq0VG7Kh-X3dGK8NhXcj@mail.gmail.com>
Subject: Re: wireless-testing or wireless-next
To: Bruno Randolf <br1@einfach.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 7:48 PM, Bruno Randolf <br1@einfach.org> wrote:
> John, Luis,
>
> I'm a little confused about which tree to use. I though we should base driver
> development on wireless-testing, but I see that you merge patches into
> wireless-next first. So should we re-base patches to wireless-next before we
> send them?

Rule of thumb is if its large use linux-next, wireless-testing just
lets you actually boot a usable kernel.

> Also, AFAIK, compat-wireless is based on linux-next, so if I want to create a
> compat-wireless package based on my latest driver changes (I need to do this
> frequently for testing my driver on my platform), I always run into problems
> because my latest driver is in wireless-testing and not in linux-next. Do you
> have any advise on a proper workflow here?

I have a "wl" branch for wireless-testing too :)  the master branch is
for linux-next.

  Luis
