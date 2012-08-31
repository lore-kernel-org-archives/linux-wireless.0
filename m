Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51465 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2HaCUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 22:20:18 -0400
Date: Thu, 30 Aug 2012 19:21:15 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 02/14] rt2x00: Align rt2400pci GPIOCSR definition with
 datasheet.
Message-ID: <20120831022115.GB2847@mannheim-rule.att.net> (sfid-20120831_042102_026179_0BCB382D)
References: <1346355248-5331-1-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-2-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-3-git-send-email-gwingerde@gmail.com>
 <20120830210522.GA158@mannheim-rule.att.net>
 <503FD633.8070307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <503FD633.8070307@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde wrote:

> I guess it could be split up, but I don't see the point. Technically
> this patch is not needed in stable, but the next patch in the series
> depends on this one and that one is targeted at stable, so therefore
> this one is targeted at stable as well.

If I were to reroll the series without unnecessary changes, would that
be useful to you?

The whole point of point releases is to fix bugs while avoiding
pointless changes, providing a stable codebase that is easy to build
on and keeping the volume of new changes to sift through when
regressions are introduced low.

Thanks,
Jonathan
