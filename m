Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:44293 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaIHNDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 09:03:09 -0400
Received: by mail-ig0-f182.google.com with SMTP id a13so2643868igq.9
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 06:03:08 -0700 (PDT)
Date: Mon, 8 Sep 2014 09:02:15 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dani Camps <danicamps81@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wmediumd performance penalty
Message-ID: <20140908130215.GA30071@localhost> (sfid-20140908_150313_344592_4A9A8621)
References: <CAD3NH5X1AYR5p8AyRyO0DFkkJUtuc_78=s6vEi-nS4UxUZfWCg@mail.gmail.com>
 <1409597534.2703.9.camel@jlt4.sipsolutions.net>
 <CAD3NH5Wimu9muPeL-zFrw=u1G3Q+8749cj0SYUmeQuLF6LKibQ@mail.gmail.com>
 <1409644512.1808.2.camel@jlt4.sipsolutions.net>
 <CAD3NH5XEfHU7KMWwrmZdZz9LKP_86b4EFogpHrnC+AhREHjOPw@mail.gmail.com>
 <20140905130325.GA26808@localhost>
 <20140905141039.GB26808@localhost>
 <CAD3NH5UEPKw58ObsW+8dpLRFMHTEq91TSd6RAkV3H8E76Ooamw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD3NH5UEPKw58ObsW+8dpLRFMHTEq91TSd6RAkV3H8E76Ooamw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 06, 2014 at 10:17:34AM +0200, Dani Camps wrote:
> Hi Bob,
> 
> Our use case is that we have some research code implemented on mac80211,
> and we want to test it over a virtual testbed with wmediumd before going on
> real hw. Being able to have realistic radio capacities would help us in our
> testing.

Ok, I see.  Well, I started poking at wmediumd code a bit this weekend,
and I have in mind a rewrite that would do what you want, and also do
it properly unlike my other hack.  I'll let you know when I have something
working or you can ping me off-list if you want to talk more about it.

-- 
Bob Copeland %% www.bobcopeland.com
