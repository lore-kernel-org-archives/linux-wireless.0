Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab2FKHYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 03:24:43 -0400
Message-ID: <1339399481.4520.4.camel@jlt3.sipsolutions.net> (sfid-20120611_092446_241565_0E85153A)
Subject: Re: [PATCH v2 4/4] mac80211: invoke the timer only with correct
 dot11MeshHWMPRootMode value
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Mon, 11 Jun 2012 09:24:41 +0200
In-Reply-To: <CAEFj987SuLhiMcdhu6rRUn-UTfpgJ2Oe1wVhQyq41QZTOrwZhw@mail.gmail.com> (sfid-20120609_181156_971493_D13216FB)
References: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
	 <1339043963-2043-5-git-send-email-yeohchunyeow@gmail.com>
	 <1339231619.4539.32.camel@jlt3.sipsolutions.net>
	 <CAEFj987SuLhiMcdhu6rRUn-UTfpgJ2Oe1wVhQyq41QZTOrwZhw@mail.gmail.com>
	 (sfid-20120609_181156_971493_D13216FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-06-10 at 00:11 +0800, Yeoh Chun-Yeow wrote:
> > so, humm, there's still the same constant here.
> >
> > and here.
> >
> 
> Possible to stick to the number, because in the standard it define
> (0) no root
> (2) proactive PREQ no PREP
> (3) proactive RPEQ with PREP
> (4) RANN
> 
> Not so sure what's the proper naming for this constant.

You could make up a name, or use >= 2 instead of > 1 ?

johannes

