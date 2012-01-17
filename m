Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:30990 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab2AQXGv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 18:06:51 -0500
Date: Wed, 18 Jan 2012 00:05:58 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCHv4 2/2] mac80211: in IBSS use the Auth frame to trigger
 STA reinsertion
Message-ID: <20120117230530.GA11302@ritirata.org> (sfid-20120118_000654_760135_96CC0DE4)
References: <1326839644-16902-1-git-send-email-ordex@autistici.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1326839644-16902-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 17, 2012 at 11:34:04 +0100, Antonio Quartulli wrote:
> In case of a node re-joining the cell the sta_info structure belonging to it is
> first destroyed and then reinserted. In this way its internal state is reset.
> 
> The joining operation is recognised thank the Auth frame being received.
> 
> This operation is helpful in case of a node being rebooted that is joining the
> ad-hoc cell again, before its purge timeout on other nodes expires.
> 
> Signed-off-by: Antonio Quartulli <ordex@autistici.org>
> ---

Ok. I found another little mistake. Please drop either patch 1/2 and patch 2/2.
I'm going to resend the patchset again.

Regards,

-- 
Antonio Quartulli

..each of us alone is worth nothing..
Ernesto "Che" Guevara
