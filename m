Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:24859 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbXIBPzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2007 11:55:16 -0400
Received: by py-out-1112.google.com with SMTP id u77so4420404pyb
        for <linux-wireless@vger.kernel.org>; Sun, 02 Sep 2007 08:55:15 -0700 (PDT)
Message-ID: <40f31dec0709020855q10d9227bld6e594ea57ba8142@mail.gmail.com>
Date: Sun, 2 Sep 2007 18:55:15 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 3/5] Net: ath5k, use int as retval
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <46D9C6A8.7070600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2713029743177393055@pripojeni.net>
	 <2440910618305782004@pripojeni.net>
	 <20070830124054.GC5140@tuxdriver.com> <46D9C6A8.7070600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/9/1, Jiri Slaby <jirislaby@gmail.com>:
> John W. Linville napsal(a):
> > On Tue, Aug 28, 2007 at 12:00:09PM -0400, Jiri Slaby wrote:
> >> ath5k, use int as retval
> >>
> >> Convert some functions to return int and proper negative return value on
> >> error as we are used to.
> >
> > Since I didn't apply 1/5, this one didn't apply either.  It seems
> > fine overall, so if you rediff I'll be happy to apply.
>
> Ok, I'll do it, thanks,

Can somebody commit my resent changes from madwifi-svn (cleanups,
kconfig, remove_hw_ from filenames etc) ? I don't have git repository
;-(


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
