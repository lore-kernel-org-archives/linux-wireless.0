Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56291 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab2HaLOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 07:14:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120831022115.GB2847@mannheim-rule.att.net>
References: <1346355248-5331-1-git-send-email-gwingerde@gmail.com>
	<1346355248-5331-2-git-send-email-gwingerde@gmail.com>
	<1346355248-5331-3-git-send-email-gwingerde@gmail.com>
	<20120830210522.GA158@mannheim-rule.att.net>
	<503FD633.8070307@gmail.com>
	<20120831022115.GB2847@mannheim-rule.att.net>
Date: Fri, 31 Aug 2012 13:14:45 +0200
Message-ID: <CAL1gcdP6S2PByOOEJq+AZOgUGqOVsWvcq1DXWo60ni2-iavpgA@mail.gmail.com> (sfid-20120831_131451_615396_75E5C066)
Subject: Re: [PATCH 02/14] rt2x00: Align rt2400pci GPIOCSR definition with datasheet.
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jonathan,

On Fri, Aug 31, 2012 at 4:21 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> Gertjan van Wingerde wrote:
>
>> I guess it could be split up, but I don't see the point. Technically
>> this patch is not needed in stable, but the next patch in the series
>> depends on this one and that one is targeted at stable, so therefore
>> this one is targeted at stable as well.
>
> If I were to reroll the series without unnecessary changes, would that
> be useful to you?

Nevermind, I'll refactor the series myself to reduce the number of
patches and to better separate the fixes from the clean-ups.
I can probably do that much faster (within an hour) than you can.

>
> The whole point of point releases is to fix bugs while avoiding
> pointless changes, providing a stable codebase that is easy to build
> on and keeping the volume of new changes to sift through when
> regressions are introduced low.
>

I agree. However, in this case I tried to balance new development with
bug fixing to prevent a lot of double work (and failed to do so).

---
Gertjan
