Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:35468 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3ITOAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 10:00:09 -0400
Received: by mail-we0-f181.google.com with SMTP id p61so512794wes.26
        for <linux-wireless@vger.kernel.org>; Fri, 20 Sep 2013 07:00:08 -0700 (PDT)
Message-ID: <523C54E5.8030102@gmail.com> (sfid-20130920_160013_576530_8D9DEA91)
Date: Fri, 20 Sep 2013 16:00:05 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Felix Heinonen <fheinonen@gmail.com>
CC: users@rt2x00.serialmonkey.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Zyxel NWD2705 testing
References: <523AFA40.3000503@gmail.com> <CALcAVvn9tkDGYxw8eEZszmEj94wNhYH1oG8zaFYNVu1VvjHWLg@mail.gmail.com>
In-Reply-To: <CALcAVvn9tkDGYxw8eEZszmEj94wNhYH1oG8zaFYNVu1VvjHWLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2013 10:23 AM, Felix Heinonen wrote:

> The reason why I asked about testing was that it was added as a
> supported device, instead it prevents shutting down the computer
> if the adapter is connected.
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/linville/wireless-next/+/637065267eab4817c0b06cbf3c7fc80842acab99

Support for RT3573 was added recently, and still it's experimental.
You should use wireless-next or latest torvalds tree.

You can post a complete bug report to bugzilla [1] and/or linux-wireless,
rt2x00 mailing lists.


[1] http://bugzilla.kernel.org
