Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49652 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1H3Gdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 02:33:55 -0400
Subject: Re: [PATCH v2] mac80211: add flag to indicate HW only Tx-agg setup
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1314685958-24855-1-git-send-email-arik@wizery.com> (sfid-20110830_083313_960988_FD30FB1C)
References: <1314685958-24855-1-git-send-email-arik@wizery.com>
	 (sfid-20110830_083313_960988_FD30FB1C)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 08:33:52 +0200
Message-ID: <1314686032.4011.18.camel@jlt3.sipsolutions.net> (sfid-20110830_083357_029497_B1EEBA9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-30 at 09:32 +0300, Arik Nemtsov wrote:
> When this flag is set, Tx A-MPDU sessions will not be started by
> mac80211. This flag is required for devices that support Tx A-MPDU setup
> in hardware.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> v2: changed flag name and description to clear up its purpose

Thanks :)

johannes

