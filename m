Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44053 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbYLSOpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 09:45:12 -0500
Date: Fri, 19 Dec 2008 09:42:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] [RFC] mac80211: Disable HT negotiation with TKIP/WEP
	as pairwise cipher
Message-ID: <20081219144256.GB4041@tuxdriver.com> (sfid-20081219_154530_033418_2087BF52)
References: <1229692235-21734-1-git-send-email-vasanth@atheros.com> <20081219142822.GA4041@tuxdriver.com> <494BB0BE.3030705@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <494BB0BE.3030705@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 08:03:34PM +0530, Vasanthakumar Thiagarajan wrote:
> John W. Linville wrote:
> > On Fri, Dec 19, 2008 at 06:40:35PM +0530, Vasanthakumar Thiagarajan wrote:
> >> IEEE802.11n does not allow TKIP/WEP as pairwise cipher in HT mode.
> >> Connect in non-ht mode if either of these ciphers is cofigured as
> >> pairwise.
> >>
> >> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > 
> > Are there perhaps any broken APs out there that support such a
> > configuration?  I would hate to prevent users from connecting simply
> > out of blind obedience to the standard.
> 
> This particular configuration is not allowed in the latest 11n draft (7.0).
> Yes, we have quite a few AP's around which support this configuration. 

Honestly, as a STA I would rather violate the standard and connect
to the coffee shop's broken/misconfigured pre-draft7 .11n AP than stand
on principle and have to fall back on my cell phone's data plan or sip
my latte in internet silence... :-)

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
