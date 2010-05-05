Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab0EEGpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 02:45:09 -0400
Subject: Re: [PATCH] compat-wireless: updates for orinoco
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
In-Reply-To: <v2u43e72e891005041626n14deaca5z284f2472e909c923@mail.gmail.com>
References: <1273012850-8359-1-git-send-email-hauke@hauke-m.de>
	 <v2u43e72e891005041626n14deaca5z284f2472e909c923@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 08:45:03 +0200
Message-ID: <1273041903.3728.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-04 at 16:26 -0700, Luis R. Rodriguez wrote:

> void netdev_attach_ops(struct net_device *dev,
>                       const struct net_device_ops *ops)
> {
> #define SET_NETDEVOP(_op) (_op ? _op : NULL)

isn't that like the dumbest macro ever?

johannes

