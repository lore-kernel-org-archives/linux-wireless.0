Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55415 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbYLSOaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 09:30:12 -0500
Date: Fri, 19 Dec 2008 09:28:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Jouni.Malinen@atheros.com
Subject: Re: [PATCH] [RFC] mac80211: Disable HT negotiation with TKIP/WEP
	as pairwise cipher
Message-ID: <20081219142822.GA4041@tuxdriver.com> (sfid-20081219_153017_468370_CCF68135)
References: <1229692235-21734-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229692235-21734-1-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 06:40:35PM +0530, Vasanthakumar Thiagarajan wrote:
> IEEE802.11n does not allow TKIP/WEP as pairwise cipher in HT mode.
> Connect in non-ht mode if either of these ciphers is cofigured as
> pairwise.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Are there perhaps any broken APs out there that support such a
configuration?  I would hate to prevent users from connecting simply
out of blind obedience to the standard.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
