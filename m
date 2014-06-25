Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52757 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaFYSsA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 14:48:00 -0400
Message-ID: <1403722063.4140.19.camel@jlt4.sipsolutions.net> (sfid-20140625_204804_429344_345F2863)
Subject: Re: [PATCH v11 0/5] cfg/mac80211: implement multi-vif csa
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Wed, 25 Jun 2014 20:47:43 +0200
In-Reply-To: <1403692510-27873-1-git-send-email-michal.kazior@tieto.com> (sfid-20140625_125156_450669_F30606F7)
References: <1403692510-27873-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140625_125156_450669_F30606F7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-06-25 at 12:35 +0200, Michal Kazior wrote:
> Hi,
> 
> The patchset implements multi-interface
> reservations and multi-interface channel
> switching.
> 
> There are still some cases that aren't handled
> well (at least degradation of number of channels
> due to interface combinations that I'm aware of).
> 
> 
> v11:
>  * rebase to latest mac80211-next/master
>    (eb6a61549f530f1cc435512df3799f656094ba83)
>  * lots of fixes (see notes in [1/5])

Applied all.

johannes

