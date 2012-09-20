Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50195 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2ITGdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 02:33:03 -0400
Received: by qcro28 with SMTP id o28so1467746qcr.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2012 23:33:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6ryRXB6GjymaP-RM8HTEeWRHnE8B=5tdH3J4JGyeHBEE6Q@mail.gmail.com>
References: <1348053493-22955-1-git-send-email-jarl@softace.dk>
 <1348053493-22955-2-git-send-email-jarl@softace.dk> <CAOjsGA2uvCxnX1PH85w2vO894kZT+af-Tgj7bV-3kw3ScxN10g@mail.gmail.com>
 <CACna6ryRXB6GjymaP-RM8HTEeWRHnE8B=5tdH3J4JGyeHBEE6Q@mail.gmail.com>
From: Jarl Friis <jarl@softace.dk>
Date: Thu, 20 Sep 2012 08:32:42 +0200
Message-ID: <CAOjsGA3cmuGHY1WAJ92RwbUf1iNpFHaSvePxvzSYxkY1FJzjkw@mail.gmail.com> (sfid-20120920_083309_017338_235BA308)
Subject: Re: [PATCH 2/2] Using LP firmware for taking advantage of the
 low-power capabilities.
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/20 Rafał Miłecki <zajec5@gmail.com>:
> Well, your BCM4322 is not LP-PHY card... does it really work better
> after that change, and wakes up faster? ;)

That was my un-scientific impression, yes (probably biased by
expectations, right? :-) ). But it could also be that I was using a
more upstream kernel than the stock ubuntu kernel. I don't know :-)

> BCM4313 is LCN-PHY, so your change won't affect it, not to mention it
> is not supported by b43.
>
> 14e4:4315 is really BCM4312 (LP-PHY) and maybe could be affected by
> this patch... but just in case of core 16. AFAIK our 14e4:4315 are
> usually devices with core rev 15.

Thanks for clearing that out...

Jarl
