Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:2150 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbcETKqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 06:46:34 -0400
Subject: Re: Who is the maintainer of net/wireless/wext* ?
To: sedat.dilek@gmail.com, Ujjal Roy <royujjal@gmail.com>
References: <CAE2MWkk=mw0XiuimAQafTv=XtnBm2bCxH4Mf52veXgce6W8MrA@mail.gmail.com>
 <CA+icZUUkx74CgNbNJt5pqoqWHWQNTNCfP2faDSW7H9VmSuj1KQ@mail.gmail.com>
Cc: Kernel <linux-wireless@vger.kernel.org>
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <573EEB06.70109@neratec.com> (sfid-20160520_124638_225462_60BE0A70)
Date: Fri, 20 May 2016 12:46:30 +0200
MIME-Version: 1.0
In-Reply-To: <CA+icZUUkx74CgNbNJt5pqoqWHWQNTNCfP2faDSW7H9VmSuj1KQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/2016 12:34 PM, Sedat Dilek wrote:
> On 5/20/16, Ujjal Roy <royujjal@gmail.com> wrote:
>> I want to know the maintainer of
>>
>> net/wireless/wext*. Please any reply.
>>
> 
> For example, you can look in the MAINTAINERS file.
> 
> CFG80211 and NL80211
> M:	Johannes Berg <johannes@sipsolutions.net>
> L:	linux-wireless@vger.kernel.org
> W:	http://wireless.kernel.org/
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
> S:	Maintained
> F:	include/uapi/linux/nl80211.h
> F:	include/net/cfg80211.h
> F:	net/wireless/*
> X:	net/wireless/wext*
> 
> - Sedat -
> 
> [1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS#n2890

Maybe also helpful: ./scripts/get_maintainer.pl -f net/wireless/wext*

Cheers,
Zefir
