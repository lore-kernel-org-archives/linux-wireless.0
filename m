Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48320 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaC1JrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 05:47:07 -0400
Message-ID: <1396000023.4175.14.camel@jlt4.sipsolutions.net> (sfid-20140328_104711_348135_ED6998E3)
Subject: Re: pull request: mac80211-next-csa 2014-03-24
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 28 Mar 2014 10:47:03 +0100
In-Reply-To: <1395650268.4515.21.camel@dubbel>
References: <1395650268.4515.21.camel@dubbel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-24 at 10:37 +0200, Luca Coelho wrote:
> Hi Johannes,
> 
> As we agreed, I'm sending you a pull request with the channel-switch
> stuff Michał and I have been working on.
> 
> This includes my combination and reservation patchsets and the VLAN copy
> chanctx from Michał that my reservation patchset depends on.

I've cherry-picked the patches to resolve some conflicts in the patches
themselves rather than in the merge, since I'll likely need to rebase
after the merge window.

johannes

