Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54325 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab0JDXuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 19:50:25 -0400
Received: by iwn5 with SMTP id 5so7535952iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 16:50:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101004224754.GA16357@jm.kir.nu>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
 <1286198845.3620.37.camel@jlt3.sipsolutions.net> <20101004164149.GE2105@tux>
 <1286210566.3620.42.camel@jlt3.sipsolutions.net> <20101004172504.GL2105@tux>
 <1286213426.3620.43.camel@jlt3.sipsolutions.net> <20101004173507.GN2105@tux>
 <20101004203900.GA14524@jm.kir.nu> <AANLkTinwwvsLzovff4DKTktWuD6UdbRiEAs3g6jj-94Q@mail.gmail.com>
 <20101004224754.GA16357@jm.kir.nu>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 4 Oct 2010 16:50:02 -0700
Message-ID: <AANLkTi=8pxhqN9p4QP3T_wmUmsHJfqOBRYDi9w_0BUkw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mac80211: fix rate_control_send_low warnings for delbas
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 4, 2010 at 3:47 PM, Jouni Malinen <j@w1.fi> wrote:
> On Mon, Oct 04, 2010 at 02:07:22PM -0700, Luis R. Rodriguez wrote:
>> Jouni, just to be clear so you are fine with dropping explicitly the
>> tear down of the BA agreement to the old AP?
>
> If you are talking about not transmitting a frame, then yes, but
> obviously, we would still need to locally tear down whatever we have set
> up..

Sure.

> I think it would be a good default policy to not send any frames to the
> old AP after we have decided to roam to a new one. If this does not work
> well in some networks, I would like to here more detailed description on
> what exactly is happening.

No that's fine, I just was curious how the bridge stuff you described
was handled in enterprise networks, you would know better :)

OK -- so lets go with Johanne's patch instead of patch 2 and 3 as he
suggested :)

  Luis
