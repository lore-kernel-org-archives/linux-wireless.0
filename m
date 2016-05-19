Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:34385 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbcESEI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 00:08:29 -0400
Date: Wed, 18 May 2016 21:08:27 -0700 (PDT)
Message-Id: <20160518.210827.2298957890402906546.davem@davemloft.net> (sfid-20160519_060852_376487_E8552401)
To: torvalds@linux-foundation.org
Cc: luciano.coelho@intel.com, reinoudkoornstra@gmail.com,
	linux-kernel@vger.kernel.org, linuxwifi@intel.com,
	johannes.berg@intel.com, akpm@linux-foundation.org,
	kvalo@codeaurora.org, egrumbach@gmail.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFxThzV3myrHv0XZbubEdGhg5=rGE6dK=+L1ddc9sufdCQ@mail.gmail.com>
References: <CAAA5faHtbt8oyKEQOJ+NMBKR24b7Nvm6uJ2qZid1sWY58e7f+A@mail.gmail.com>
	<1463581411.29999.1.camel@intel.com>
	<CA+55aFxThzV3myrHv0XZbubEdGhg5=rGE6dK=+L1ddc9sufdCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 May 2016 11:45:06 -0700

> David, do you happen to recall that merge conflict? I think you must
> have removed that "skb_info" variable declaration and initialization
> manually (due to the "unused variable" warning, which in turn was due
> to the incorrect merge of the actual conflict), because I think git
> would have merged that line into the result.

Yes, I know I buggered this merge conflict and Kalle said he'd have
a fix coming my way ASAP.

Sorry, I was travelling today, so I'll catch up with this tomorrow.
