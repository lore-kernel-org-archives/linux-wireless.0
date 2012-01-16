Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:23555 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab2APSSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 13:18:07 -0500
Date: Mon, 16 Jan 2012 19:16:20 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 2/2] mac80211: in IBSS use the Auth frame to trigger
 STA reinsertion
Message-ID: <20120116181619.GA12673@ritirata.org> (sfid-20120116_191810_920762_2454142F)
References: <1326462778-7251-1-git-send-email-ordex@autistici.org>
 <1326462778-7251-2-git-send-email-ordex@autistici.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1326462778-7251-2-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 13, 2012 at 02:52:58 +0100, Antonio Quartulli wrote:
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

Please, don't consider this v2 2/2 patch. I sent v3 2/2.

Regards,

-- 
Antonio Quartulli

..each of us alone is worth nothing..
Ernesto "Che" Guevara
