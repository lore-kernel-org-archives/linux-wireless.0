Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:11379 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbXICGdT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 02:33:19 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1297388fkz
        for <linux-wireless@vger.kernel.org>; Sun, 02 Sep 2007 23:33:17 -0700 (PDT)
Message-ID: <46DBAAF0.40604@gmail.com>
Date: Mon, 03 Sep 2007 08:34:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] Net: ath5k, use int as retval
References: <2713029743177393055@pripojeni.net>	 <2440910618305782004@pripojeni.net>	 <20070830124054.GC5140@tuxdriver.com> <46D9C6A8.7070600@gmail.com> <40f31dec0709020855q10d9227bld6e594ea57ba8142@mail.gmail.com>
In-Reply-To: <40f31dec0709020855q10d9227bld6e594ea57ba8142@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis napsal(a):
> 2007/9/1, Jiri Slaby <jirislaby@gmail.com>:
>> John W. Linville napsal(a):
>>> On Tue, Aug 28, 2007 at 12:00:09PM -0400, Jiri Slaby wrote:
>>>> ath5k, use int as retval
>>>>
>>>> Convert some functions to return int and proper negative return value on
>>>> error as we are used to.
>>> Since I didn't apply 1/5, this one didn't apply either.  It seems
>>> fine overall, so if you rediff I'll be happy to apply.
>> Ok, I'll do it, thanks,
> 
> Can somebody commit my resent changes from madwifi-svn (cleanups,
> kconfig, remove_hw_ from filenames etc) ? I don't have git repository
> ;-(

Resent to where? Or what do you mean?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
