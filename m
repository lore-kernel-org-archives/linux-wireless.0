Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20530 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZJZVcS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 17:32:18 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 14:32:24 -0700
Date: Mon, 26 Oct 2009 14:32:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kalle Valo <kalle.valo@iki.fi>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH v2 2/4] ath9k_hw: distinguish single-chip solutions on
	initial probe print
Message-ID: <20091026213222.GA3956@tux>
References: <1256575447-4591-1-git-send-email-lrodriguez@atheros.com> <87d449hp73.fsf@purkki.valot.fi> <20091026204447.GA5713@tux> <878wexhn6m.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <878wexhn6m.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 02:15:13PM -0700, Kalle Valo wrote:
> "Luis R. Rodriguez" <lrodriguez@Atheros.com> writes:
> 
> >> I think you should provide the size of hw_name to this function and
> >> use snprintf() to avoid writing out of bounds.
> >
> > I was going to do this but since I know the users of it and control
> > it seemed to not matter. I'll respin with this added, better to be careful.
> 
> Yeah, you never know if someone (for example a crazy Finn just after a
> refreshing sauna) comes along, changes the function a bit "to clean it
> up" and creates a subtle bug ;)

Ah yes, forgot about the crazy sauna fins, must fix now for sure.

  Luis
