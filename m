Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:38770 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbJEKB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:01:27 -0400
Date: Mon, 05 Oct 2015 03:17:04 -0700 (PDT)
Message-Id: <20151005.031704.767722033063704258.davem@davemloft.net> (sfid-20151005_120134_610912_3CA88ECB)
To: arnd@arndb.de
Cc: netdev@vger.kernel.org, y2038@lists.linaro.org,
	linux-kernel@vger.kernel.org, coreteam@netfilter.org,
	intel-wired-lan@lists.osuosl.org, linux-api@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net, linux-can@vger.kernel.org,
	linux-sctp@vger.kernel.org, linux-wireless@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 00/12] net: assorted y2038 changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1443612402-3000775-1-git-send-email-arnd@arndb.de>
References: <1443612402-3000775-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 30 Sep 2015 13:26:30 +0200

> This is a set of changes for network drivers and core code to
> get rid of the use of time_t and derived data structures.

Applied patches #1-#10 to net-next, using the updated v2 version of
the zatm change.
