Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55969 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab0EJNaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 09:30:13 -0400
Date: Mon, 10 May 2010 09:26:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: remove deprecated noise field from
 ieee80211_rx_status
Message-ID: <20100510132649.GB11681@tuxdriver.com>
References: <1272656351-5983-1-git-send-email-linville@tuxdriver.com>
 <201005101015.50172.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201005101015.50172.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 10, 2010 at 10:15:50AM +0900, Bruno Randolf wrote:
> On Saturday 01 May 2010 04:39:11 John W. Linville wrote:
> > Also remove associated IEEE80211_HW_NOISE_DBM from ieee80211_hw_flags.
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
> sorry for the late reply:
> 
> please, don't... this way we loose the information which drivers can report 
> noise values and which can't.

Well, I'm afraid it's already on its way.  Anyway, we can rely on the
git logs to track that information, and I've got a personal TODO for
implementing basic survey support for those drivers.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
