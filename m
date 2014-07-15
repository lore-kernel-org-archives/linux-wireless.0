Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:45566 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065AbaGOX1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 19:27:34 -0400
Date: Tue, 15 Jul 2014 16:27:31 -0700 (PDT)
Message-Id: <20140715.162731.976775911116907392.davem@davemloft.net> (sfid-20140716_012750_706506_A0F5DED6)
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, joe@perches.com,
	v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
	linux-zigbee-devel@lists.sourceforge.net,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-s390@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, linux-sctp@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH 00/16] net: remove unnecessary break after goto/return
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405355467-7350-1-git-send-email-fabf@skynet.be>
References: <1405355467-7350-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 14 Jul 2014 18:30:50 +0200

> Small patchset addressing break redundancy on net branch
> (suggested by Joe Perches).

Series applied, thanks Fabian.
