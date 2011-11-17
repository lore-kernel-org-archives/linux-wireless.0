Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:49703 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1KQTgC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 14:36:02 -0500
Date: Thu, 17 Nov 2011 14:34:45 -0500 (EST)
Message-Id: <20111117.143445.52753444311198143.davem@davemloft.net> (sfid-20111117_203606_785733_D090FD6C)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2011-11-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111117182939.GD32622@tuxdriver.com>
References: <20111117182939.GD32622@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 17 Nov 2011 13:29:39 -0500

> Here is a huge pull request for wireless bits intended for 3.3.  I
> reckon that the extended release cycle for 3.1 led to a backlog of new
> work that appeared during the merge window for 3.2?
> 
> At any rate...there is a big Bluetooth pull with a lot of code
> refactoring; a lot of brcm80211 bits including cleanups, refactoring,
> and some new hardware support; the normal set of iwlwifi updates plus
> some refactoring; an unusual large flurry of mac80211 and cfg80211
> updates from Johannes (including the new wireless TX status socket
> option); some updates to the new NFC subsystem; and the usual collection
> of other driver and mac80211 updates.  This also includes a pull of the
> wireless.git tree to resolve some build issues.

Pulled, thanks John.
