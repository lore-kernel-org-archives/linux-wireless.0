Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f179.google.com ([209.85.222.179]:60588 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0CATEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 14:04:16 -0500
Received: by pzk9 with SMTP id 9so2145421pzk.25
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 11:04:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <33a0299c1002281758k50590f14gd03c84af2b50e5fa@mail.gmail.com>
References: <33a0299c1002281758k50590f14gd03c84af2b50e5fa@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Mar 2010 11:03:56 -0800
Message-ID: <43e72e891003011103g1f7a08b9g8b70681828618d6@mail.gmail.com>
Subject: Re: ath9k: cannot "make", have to "make clean" first
To: Anthony Le <lazugau@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 28, 2010 at 5:58 PM, Anthony Le <lazugau@gmail.com> wrote:
> Hi all,
> I'm using Ubuntu 9.10.
> I modified a source file in ath9k driver. And then tried to do "make"
> But it said: there is nothing to be done with 'all'
>
> I have to do "make clean" and then "make" to rebuild all. And it takes
> long time.
>
> Can you tell me why? and how to overcome this?

Provided you are talking about compat-wireless this is some Makefile
issue, fixed on bleeding edge compat-wireless. I should port it to the
stable releases but haven't yet.

  Luis
