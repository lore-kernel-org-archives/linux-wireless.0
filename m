Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39457
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbXLYE5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 23:57:21 -0500
Date: Mon, 24 Dec 2007 20:57:12 -0800 (PST)
Message-Id: <20071224.205712.66730805.davem@davemloft.net> (sfid-20071225_045726_142339_39D681B0)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: (2nd attempt) Please pull 'upstream-davem' branch of
 wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071221140527.GA19874@tuxdriver.com>
References: <20071220223850.GL3139@tuxdriver.com>
	<20071220.200429.242105762.davem@davemloft.net>
	<20071221140527.GA19874@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 21 Dec 2007 09:05:27 -0500

> These are destined for 2.6.25.  The patches fall mostly into two
> categories: a new rate control algorithm for mac80211, and some
> cfg80211 enhancements (including mac80211 patches to use them).
> 
> Also there are some small hits in the iwlwifi drivers related to
> rate control.  I'll CC Jeff since his tree has a lot of iwlwifi symbol
> renames and those patches will conflict (or break the build, or both)
> when your tree and his finally come together.
> 
> Let me know if there are any problems!

Pulled, thanks a lot!
