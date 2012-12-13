Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:45099 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab2LMUd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 15:33:28 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2173876lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 12:33:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7DDF37406E10F0438561DBB78326DF390391C15265@SC-VEXCH1.marvell.com>
References: <20121123081444.GA6028@markyou.marvell.com> <20121211194249.GT15974@pogo>
 <50C9F3FA.6000906@gmail.com> <7DDF37406E10F0438561DBB78326DF390391C15265@SC-VEXCH1.marvell.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 13 Dec 2012 12:33:06 -0800
Message-ID: <CAB=NE6WYYzgOWeG=2UHccp74=-qp2Cvv=SZGY75+5jN4-y0orA@mail.gmail.com> (sfid-20121213_213331_551476_417CAFB8)
Subject: Re: ACS and Hostapd
To: Yogesh Powar <yogeshp@marvell.com>
Cc: Jonathan Bither <jonbither@gmail.com>, "j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	Matt Smith <smithm@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 13, 2012 at 10:54 AM, Yogesh Powar <yogeshp@marvell.com> wrote:
> Hi Jouni/Luis,
>
> It seems that, we have some resources that can be utilized to test this
> feature of ACS for hostapd.
>
> Before we begin on this work of Luis and optimize/enhance it further, would you
> like to recommend some immediate changes from the last test results?

By my part:

The algorithm I wrote was pretty complex and although I did review it
with some folks who liked it and it made sense the algorithm can be
simplified by taking the input elements and using a multiplier for
each one and letting the user configure the multiplier. In other words
all the log stuff I did and linearizing it some way was not all that
necessary except for mental masturbation.

Apart from that its just a matter of testing and proving it works.

  Luis
