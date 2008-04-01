Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:29227 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751282AbYDABxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 21:53:33 -0400
From: bruno randolf <bruno@thinktube.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211 bug? no data is being transmitted after interface is brought down and then up again
Date: Tue, 1 Apr 2008 10:53:19 +0900
Cc: Thomas =?iso-8859-1?q?B=E4chler?= <thomas@archlinux.org>,
	linux-wireless@vger.kernel.org
References: <fsm20k$usk$1@ger.gmane.org> <20080331190225.GA12933@tuxdriver.com>
In-Reply-To: <20080331190225.GA12933@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200804011053.19675.bruno@thinktube.com> (sfid-20080401_025338_903545_9B6E0EB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 April 2008 04:02:25 John W. Linville wrote:
> On Sat, Mar 29, 2008 at 07:32:51PM +0100, Thomas B=E4chler wrote:
> > My question is, should this be considered a bug in mac80211?
> > IMO, when an interface is brought down and then up again, one of th=
e
> > following things should happen:
> > 1) Everything works as before
> > 2) Nothing works, but the card disassociates from the network.
>
> #2 would be my vote.

why is that? would it be so difficult to provide #1?

from a usability point of view #1 would be clearly better. whatever the=
 state=20
was before, when i bring the interface up it want it to work (associate=
, join=20
IBSS) and be able to transmit data.

bruno
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
