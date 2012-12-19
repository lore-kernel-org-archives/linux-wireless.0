Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49270 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2LSUj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 15:39:27 -0500
Date: Wed, 19 Dec 2012 12:39:26 -0800 (PST)
Message-Id: <20121219.123926.1847105130884132288.davem@davemloft.net> (sfid-20121219_213952_045505_91CDCD88)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-12-19
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121219183220.GB1912@tuxdriver.com>
References: <20121219183220.GB1912@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 19 Dec 2012 13:32:20 -0500

> Please pull these fixes for the 3.8 stream.
> 
> Gabor Juhos provides and rt2x00 fix to properly clear-out the skb->cb
> for reporting tx_status.  Recent changes made this necessary where it
> previously was not.
> 
> Vladimir Kondratiev gives us a fix for a build issue that caused some
> ath9k devices to be skipped in the build based on unrelated config
> choices.

Pulled, thanks John.
