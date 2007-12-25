Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56864
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbXLYGHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 01:07:40 -0500
Date: Mon, 24 Dec 2007 22:07:40 -0800 (PST)
Message-Id: <20071224.220740.210148455.davem@davemloft.net> (sfid-20071225_060746_054538_CBAE072D)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please pull 'fixes-davem' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071220155227.GE3139@tuxdriver.com>
References: <20071220155227.GE3139@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 20 Dec 2007 10:52:27 -0500

> A few more stragglers for 2.6.24...let me know if there are any
> problems!
...
> The following changes since commit 82d29bf6dc7317aeb0a3a13c2348ca8591965875:
>   Linus Torvalds (1):
>         Linux 2.6.24-rc5
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git fixes-davem
> 
> Johannes Berg (2):
>       mac80211: round station cleanup timer
>       mac80211: warn when receiving frames with unaligned data

Pulled and pushed back out to net-2.6, thanks John.
