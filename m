Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44343 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab3FEOhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 10:37:24 -0400
Received: by mail-ie0-f174.google.com with SMTP id aq17so3697059iec.5
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 07:37:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130605161445.309a2942@north>
References: <20130605161445.309a2942@north>
Date: Wed, 5 Jun 2013 16:37:21 +0200
Message-ID: <CAGXE3d_TRYRA-o0K+zL-76rp0Xsv98bQnOPRJVepAP+iogrsTg@mail.gmail.com> (sfid-20130605_163735_291691_413A6C3A)
Subject: Re: Incorrect resolution of merge conflict in net/mac80211/iface.c
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 5, 2013 at 4:14 PM, Jakub Kicinski <kubakici@wp.pl> wrote:
> Hi John,
>
> I'm afraid merge in commit 84e46e17c8 of wireless-testing is
> not correct.  I don't know how would you like to resolve this
> technical error, I attach my fixup patch in case it will help
> you.  You may also want to take a look at commit a0f5d4b3a3
> of linux-next, I believe Stephen have merged two offending
> patches correctly there.
>
> BTW I think the way MAC addresses of active monitors are
> handled for devices that use address masks need some work
> on its own I hope to send a fix for that later this week.

Indeed, good catch. Stephens merge looks correct to me.
Helmut
