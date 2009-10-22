Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:41088 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbZJVQKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 12:10:41 -0400
Date: Thu, 22 Oct 2009 09:10:21 -0700
From: Jouni Malinen <j@w1.fi>
To: =?utf-8?B?QmrDtnJu?= Smedman <bjorn.smedman@venatech.se>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: mac80211/ath9k/hostapd: Some clients unable to associate with
	AP
Message-ID: <20091022161021.GA5532@jm.kir.nu>
References: <133e8d7e0910200711s7c44b899nbcd5f1037cc5ee49@mail.gmail.com> <133e8d7e0910210448y39551160o7a12a8af2da43f85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <133e8d7e0910210448y39551160o7a12a8af2da43f85@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2009 at 01:48:09PM +0200, Björn Smedman wrote:

> I've now checked the latest compat-wireless snapshot (2009-10-21) and
> it has the same problem: Windows based clients with 11g or 11b cards
> cannot connect to a mac80211/ath9k/hostapd based AP. It used to work
> with compat-wireless-2009-06-02.

> Any ideas on how to track this down? I can enable some logs and hack
> together some patches to track this down, I'm just not sure where to
> start. Bisecting is difficult for me as I can only build
> compat-wireless and only on OpenWrt... Thanx for any help in advance.

Would you be able to send me a wireless capture log (i.e., the binary
file with all the frames, not such a text dump of some information)
showing the frames exchanged in the failure and success cases? I would
be especially interested in seeing the Beacon frames which were not
shown in your previous message. I'm currently traveling and cannot
easily try to reproduce this before returning home.

-- 
Jouni Malinen                                            PGP id EFC895FA
