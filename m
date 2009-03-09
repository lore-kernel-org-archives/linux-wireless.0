Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:63753 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZCIPEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 11:04:12 -0400
Received: by fxm24 with SMTP id 24so1276220fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 08:04:09 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: handle failed scan requests in STA mode
Date: Mon, 9 Mar 2009 16:03:58 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <200903091547.09223.helmut.schaa@gmail.com> <1236610200.4205.82.camel@johannes.local>
In-Reply-To: <1236610200.4205.82.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903091603.59050.helmut.schaa@gmail.com> (sfid-20090309_160430_515701_E2696AAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 9. M=E4rz 2009 schrieb Johannes Berg:
> On Mon, 2009-03-09 at 15:47 +0100, Helmut Schaa wrote:
> > Johannes, do you think it is worth to add something like a scan wat=
chdog that
> > triggers after 30 seconds to cfg80211 and prints "scan request fail=
ed", cancels
> > the scan request and notifies user space?
>=20
> But I don't really think it's worth doing that.

=46ine with me. This was just a quick idea on how we could easily spot =
such=20
bugs in the future (for example when fullmac drivers start using cfg802=
11).

Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
