Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47704 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbZJWAnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 20:43:41 -0400
Date: Thu, 22 Oct 2009 17:43:28 -0700
From: Jouni Malinen <j@w1.fi>
To: Will Dyson <will.dyson@gmail.com>
Cc: =?utf-8?B?QmrDtnJu?= Smedman <bjorn.smedman@venatech.se>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [ath9k-devel] mac80211/ath9k/hostapd: Some clients unable to
	associate with AP
Message-ID: <20091023004328.GA27049@jm.kir.nu>
References: <133e8d7e0910200711s7c44b899nbcd5f1037cc5ee49@mail.gmail.com> <133e8d7e0910210448y39551160o7a12a8af2da43f85@mail.gmail.com> <20091022161021.GA5532@jm.kir.nu> <8e6f94720910221645n2b0b1edcq29358f175a41d3ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8e6f94720910221645n2b0b1edcq29358f175a41d3ad@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 22, 2009 at 07:45:29PM -0400, Will Dyson wrote:

> I also have an ath9k-based OpenWrt router, and see the same issue when
> running the latest builds.
> 
> I've reproduced the problem with the very latest svn (which uses
> compat-wireless 2009-10-09 and kernel 2.6.30.8) and the tree as of
> 2009-06-20 (which uses compat-wirless 2009-06-02 and a local patch to
> use kernel 2.6.30). Both have hostapd 0.6.9.

> Attached are the complete binary dumps, fail.pcap and win.pcap.

Thanks! This seems to confirm that the issue is indeed related to the
sequence number on the frames not being set correctly (for other than
Beacon frames).

-- 
Jouni Malinen                                            PGP id EFC895FA
