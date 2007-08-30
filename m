Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:18854 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834AbXH3XEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 19:04:10 -0400
Received: by wx-out-0506.google.com with SMTP id h31so623747wxd
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2007 16:04:09 -0700 (PDT)
Message-ID: <9a8748490708301604k688daad8p145fb9106b442d91@mail.gmail.com>
Date: Fri, 31 Aug 2007 01:04:09 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Don't needlessly initialize variable to NULL in zd_chip (was: Re: [PATCH 13/30] net: Don't do pointless kmalloc return value casts in zd1211 driver)
Cc: "Joe Perches" <joe@perches.com>, "Daniel Drake" <dsd@gentoo.org>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	"Ulrich Kunitz" <kune@deine-taler.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070830154255.6a146c21.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <9a8748490708301320o49d8e794vc5c37ffc938006f1@mail.gmail.com>
	 <1188512393.6062.156.camel@localhost>
	 <200708310030.31713.jesper.juhl@gmail.com>
	 <20070830154255.6a146c21.randy.dunlap@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31/08/2007, Randy Dunlap <randy.dunlap@oracle.com> wrote:
...
>
> BTW:  http://marc.info/?l=linux-wireless&m=118831813500769&w=2
>
...

Heh, thanks Randy.

All too often patches get missed since I don't happen to include the
right magic person to Cc. So I generally take a "better to have one Cc
too many than miss one" approach when sending patches - otherwise I
just end up resending it several times and eventually have to bother
Andrew to move it through -mm.

I see the point of people not getting things twice, but too many
patches slip through the cracks already (and not just my patches,
that's a general problem) so I'd rather inconvenience a few people
with one extra email than missing the proper maintainer by not Cc'ing
the right list.    Picking the right list/set of people to Cc is hard!


(whoops, mistakenly didn't do a reply-to-all initially; sorry Randy,
now you'll get this mail twice ;)


--
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
