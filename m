Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9027 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbYJXVFf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 17:05:35 -0400
Subject: Re: [ath5k-devel] ath5k: badness at net/mac80211/rx.c:2200,
	status->rate_idx = 255
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0810241201r7f8ba34ej6f39a96e371849eb@mail.gmail.com>
References: <1224799927.22806.15.camel@dv>
	 <20081023213333.4t4427vw5ws8ccck-cebfxv@webmail.spamcop.net>
	 <b6c5339f0810241158t59b15861qc9eb05a3f3f032a2@mail.gmail.com>
	 <b6c5339f0810241201r7f8ba34ej6f39a96e371849eb@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 17:05:32 -0400
Message-Id: <1224882332.10804.0.camel@dv> (sfid-20081024_230540_407701_A19A6F58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-24 at 15:01 -0400, Bob Copeland wrote:
> On Fri, Oct 24, 2008 at 2:58 PM, Bob Copeland <me@bobcopeland.com> wrote:
> > http://article.gmane.org/gmane.linux.kernel.wireless.general/22711
> >
> > I guess like ath9k, rc stuff isn't setup properly, but I wouldn't know.
> 
> Err, that's tx path not rx, so maybe not.

Correct.  But
http://article.gmane.org/gmane.linux.drivers.ath5k.devel/1311 is what
I'm seeing.

-- 
Regards,
Pavel Roskin
