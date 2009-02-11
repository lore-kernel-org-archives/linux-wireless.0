Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55168
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755292AbZBKV6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 16:58:08 -0500
Date: Wed, 11 Feb 2009 13:58:01 -0800 (PST)
Message-Id: <20090211.135801.242440425.davem@davemloft.net> (sfid-20090211_225813_554997_1DE1A0C0)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-02-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090211191212.GA7033@tuxdriver.com>
References: <20090211191212.GA7033@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 11 Feb 2009 14:12:12 -0500

> Here are a few more intended for 2.6.29.  The ath5k one is already in
> -next, but it turns-out to affect 2.6.29 as well.  The two zd1211rw ones
> are one-liners that enable new hardware for that driver.
> 
> The iwlwifi patch corrects a problem (introduced by the previous iwlwifi
> fix) that disables the iwlwifi devices after suspend/resume.  It will
> conflict with what is already in -next -- just take the hunks that are
> already in -next and ignore the hunks introduced here.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
