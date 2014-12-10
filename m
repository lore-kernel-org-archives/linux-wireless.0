Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.carbon4.de ([85.214.213.20]:47268 "EHLO
	h2156042.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaLJIHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 03:07:16 -0500
Date: Wed, 10 Dec 2014 09:04:08 +0100
From: Bastian Bittorf <bittorf@bluebottle.com>
To: vadim4j@gmail.com
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v3] wireless: Supporting of IFLA_INFO_KIND rtnl attribute
Message-ID: <20141210080408.GH7713@medion.lan> (sfid-20141210_090723_029227_F1BFFEE4)
References: <1418163666-9206-1-git-send-email-vadim4j@gmail.com>
 <24A120F8-952B-4471-88A6-463CBAD168BE@holtmann.org>
 <20141209232305.GA17043@angus-think.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141209232305.GA17043@angus-think.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* vadim4j@gmail.com <vadim4j@gmail.com> [10.12.2014 08:55]:
> > have we considered also exposing the mode of this netdev. So for example sta,ap,p2p-go,p2p-client etc. If we can send dynamic updates via RTNL, we could easily tell the networking management system what type of wireless device we have here. I am thinking about it like "wlan/p2p-go" etc. Or should this be better kept strictly to "wlan".
> > 
> > And I am not sure RTNL would be capable of changing this kind strings at runtime anyway.
> 
> May be better do not mix 2 things in one attribute?

i like the idea. who is the potential audience of the attribute beside the user?  
meaning: whoever want to scan for the keyword 'wlan' can do so, even with 'wlan/xy'

bye, bastian
