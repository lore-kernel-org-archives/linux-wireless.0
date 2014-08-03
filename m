Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:56791 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaHCRhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2014 13:37:08 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: pull request: wireless-next 2014-08-01
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140802.193939.2179004210212543536.davem@davemloft.net>
Date: Sun, 3 Aug 2014 10:37:16 -0700
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Message-Id: <C2EB98EF-6873-4F44-B914-A9F89146914A@holtmann.org> (sfid-20140803_193734_446637_0F46F597)
References: <20140801165738.GA26953@tuxdriver.com> <20140802.193939.2179004210212543536.davem@davemloft.net>
To: "David S. Miller" <davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

>> Please pull this last(?) batch of wireless change intended for the
>> 3.17 stream...
> 
> When I pull this I get tons of conflicts for:
> 
> CONFLICT (content): Merge conflict in net/6lowpan/iphc.c
> 
> I don't feel comfortable fixing these up, where are they coming
> from?

I was short on time yesterday, but now I checked up on this in detail. The merge conflicts are actually simple to resolve. You can just rely on John's tree to have the more recent net/6lowpan/ tree. I should have insisted on merging net/6lowpan/ through bluetooth-next and wireless-next way earlier to avoid conflicts.

In the future we will avoid this by ensuring that all goes via bluetooth-next first. Sorry for this confusion. John mentioned these merge conflicts in his footnote.

John, do you just want to resolve the merge conflicts and send Dave a new pull request?

Regards

Marcel

