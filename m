Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:10173 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbXIAUjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 16:39:42 -0400
Received: by nf-out-0910.google.com with SMTP id f5so939944nfh
        for <linux-wireless@vger.kernel.org>; Sat, 01 Sep 2007 13:39:40 -0700 (PDT)
Message-ID: <46D9C6A8.7070600@gmail.com>
Date: Sat, 01 Sep 2007 22:08:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 3/5] Net: ath5k, use int as retval
References: <2713029743177393055@pripojeni.net> <2440910618305782004@pripojeni.net> <20070830124054.GC5140@tuxdriver.com>
In-Reply-To: <20070830124054.GC5140@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville napsal(a):
> On Tue, Aug 28, 2007 at 12:00:09PM -0400, Jiri Slaby wrote:
>> ath5k, use int as retval
>>
>> Convert some functions to return int and proper negative return value on
>> error as we are used to.
> 
> Since I didn't apply 1/5, this one didn't apply either.  It seems
> fine overall, so if you rediff I'll be happy to apply.

Ok, I'll do it, thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz

