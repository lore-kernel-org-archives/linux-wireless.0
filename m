Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2360 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbYCaTdT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 15:33:19 -0400
Date: Mon, 31 Mar 2008 15:02:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211 bug? no data is being transmitted after interface is
	brought down and then up again
Message-ID: <20080331190225.GA12933@tuxdriver.com> (sfid-20080331_203333_356166_CE46FB5E)
References: <fsm20k$usk$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <fsm20k$usk$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 29, 2008 at 07:32:51PM +0100, Thomas B=E4chler wrote:

> My question is, should this be considered a bug in mac80211?
> IMO, when an interface is brought down and then up again, one of the=20
> following things should happen:
> 1) Everything works as before
> 2) Nothing works, but the card disassociates from the network.

#2 would be my vote.

> The current behaviour (card stays associated, but no data is transmit=
ted=20
> any more) is unintuitive and costed me much time.

Seems like a bug to me.  Would you mind opening a bug at
bugzilla.kernel.org?

Thanks!

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
