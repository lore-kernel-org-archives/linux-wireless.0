Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48070
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756810AbZJLUIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 16:08:48 -0400
Date: Mon, 12 Oct 2009 13:08:44 -0700 (PDT)
Message-Id: <20091012.130844.218270782.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: kalle.valo@iki.fi, johannes@sipsolutions.net,
	hidave.darkstar@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: fix ieee80211_rx() context
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091012133835.GB27575@tuxdriver.com>
References: <87y6nhoqud.fsf@purkki.valot.fi>
	<20091011.200857.141215452.davem@davemloft.net>
	<20091012133835.GB27575@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 12 Oct 2009 09:38:36 -0400

> I'm not sure I see the difference between this and the rationale for
> having netif_rx_ni vs. an open-coded version of it?  ieee80211_rx_ni
> seems like a small amount of code (could even be inline) that
> potentially avoids some stupid bugs...?

Sure, no problem, feel free to add ieee80211_rx_ni().
