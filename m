Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:35893 "EHLO
	mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424AbcETKeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 06:34:24 -0400
Received: by mail-vk0-f65.google.com with SMTP id c189so15988898vkb.3
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2016 03:34:24 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAE2MWkk=mw0XiuimAQafTv=XtnBm2bCxH4Mf52veXgce6W8MrA@mail.gmail.com>
References: <CAE2MWkk=mw0XiuimAQafTv=XtnBm2bCxH4Mf52veXgce6W8MrA@mail.gmail.com>
Date: Fri, 20 May 2016 12:34:23 +0200
Message-ID: <CA+icZUUkx74CgNbNJt5pqoqWHWQNTNCfP2faDSW7H9VmSuj1KQ@mail.gmail.com> (sfid-20160520_123428_245082_AF2D8DAD)
Subject: Re: Who is the maintainer of net/wireless/wext* ?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ujjal Roy <royujjal@gmail.com>
Cc: Kernel <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/20/16, Ujjal Roy <royujjal@gmail.com> wrote:
> I want to know the maintainer of
>
> net/wireless/wext*. Please any reply.
>

For example, you can look in the MAINTAINERS file.

CFG80211 and NL80211
M:	Johannes Berg <johannes@sipsolutions.net>
L:	linux-wireless@vger.kernel.org
W:	http://wireless.kernel.org/
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
S:	Maintained
F:	include/uapi/linux/nl80211.h
F:	include/net/cfg80211.h
F:	net/wireless/*
X:	net/wireless/wext*

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS#n2890
