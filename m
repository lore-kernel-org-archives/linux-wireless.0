Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57264 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYDYMAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2008 08:00:55 -0400
Date: Fri, 25 Apr 2008 14:01:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?K=E1roly?= Kasza <kaszak@gmail.com>
Cc: lcostantino@gmail.com, linux-wireless@vger.kernel.org,
	someone@dunanet.hu
Subject: Re: w35und: remove some more unneccessary code
Message-ID: <20080425120133.GP14903@elf.ucw.cz> (sfid-20080425_140133_538127_C8056FB0)
References: <20080419202952.GA26630@elf.ucw.cz> <544ab8580804200956v43dfabf8p511f46eb2940093e@mail.gmail.com> <20080425111556.GJ14903@elf.ucw.cz> <544ab8580804250442n466d33e8qf72b652bf11d737e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <544ab8580804250442n466d33e8qf72b652bf11d737e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> linux/wb35reg.c, at line 566. I attached a little patch, generated
> with svn di. It makes the stuff compilable again out-of-tree too. I

I tried to apply, but it diff complained about malformed part, so I
took just the hwtype patch.

> would also recommend merging the linux/ subdir into the base and
> destroying the 0 byte files and os_common.h.
> My card outputs "16", which is Airoha AL2230
> (http://www.airoha.com.tw/AL2230.htm).

My card outputs 16, too.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
