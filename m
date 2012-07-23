Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36481 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2GWBSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2012 21:18:20 -0400
Received: by obbuo13 with SMTP id uo13so8708083obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2012 18:18:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVN7meRB2AH3Go1x-PhfXNygsq=xqKxhZ4nsJxG_b0vycw@mail.gmail.com>
References: <1342787764-26858-1-git-send-email-yeohchunyeow@gmail.com>
	<CAG6hwVN7meRB2AH3Go1x-PhfXNygsq=xqKxhZ4nsJxG_b0vycw@mail.gmail.com>
Date: Mon, 23 Jul 2012 09:18:19 +0800
Message-ID: <CAEFj9876u=63Nwv6Jz0xE_xNni66NCXyQbogu=L67cCLCEu4Ag@mail.gmail.com> (sfid-20120723_031823_757938_DD038FCA)
Subject: Re: [PATCH] mac80211: add extra checking for RC init upon receiving
 mesh beacon
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Thomas

> I think right now there is an assumption that the peer's ch_type and
> other capabilities won't change while a peering is established. In
> that case, it seems simpler to just return early if sta->plink_state
> == NL80211_PLINK_ESTAB. The sta->last_rx should probably still be
> updated though.

Thanks for your comment. Yes, I think that it will be simpler as you
mention by using plink_state. I will resubmit a patch on this.

Regards,
Chun-Yeow
