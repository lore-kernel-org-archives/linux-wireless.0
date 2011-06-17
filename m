Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:49866 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab1FQTCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 15:02:43 -0400
Date: Fri, 17 Jun 2011 15:01:35 -0400 (EDT)
Message-Id: <20110617.150135.1664074829629603538.davem@davemloft.net> (sfid-20110617_210306_352175_1EE7CDD4)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-06-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110617173613.GC6820@tuxdriver.com>
References: <20110617173613.GC6820@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 17 Jun 2011 13:36:14 -0400

> Here is a batch of fixes intended for 3.0.  Included are a regression
> for mwl8k which caused CCMP encryption to fail on that device, and an
> mwifiex fix for a null pointer dereference.  Also included is a batch
> of Bluetooth fixes from Gustavo, including a regression fix for BT 1.1
> devices, a fix for shutdown of SCO devices, a fix for an information
> leak, and a silly error-checking fix that I thought was worth including
> to prevent misinterpreting bad data as device command options.
> 
> Please let me know if there are problems!

Pulled, thanks John.
