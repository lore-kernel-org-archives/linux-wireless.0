Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:60185 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3DPO60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 10:58:26 -0400
Received: by mail-wg0-f54.google.com with SMTP id y10so567278wgg.33
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2013 07:58:25 -0700 (PDT)
Date: Tue, 16 Apr 2013 16:54:15 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/5] mac80211: fix CTS protection handling
Message-ID: <20130416145415.GA30644@magnum.frso.rivierawaves.com> (sfid-20130416_165835_682156_BBC1B76E)
References: <1366112326-92981-1-git-send-email-nbd@openwrt.org>
 <1366112326-92981-2-git-send-email-nbd@openwrt.org>
 <1366122059.8244.27.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366122059.8244.27.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 16, 2013 at 04:20:59PM +0200, Johannes Berg wrote:
> On Tue, 2013-04-16 at 13:38 +0200, Felix Fietkau wrote:
> > The rates[0] CTS and RTS flags are only set after rate control has been
> > called, so minstrel cannot use them to for setting the number of
> > retries. This patch adds two new flags to explicitly indicate RTS/CTS use.
> 
> I applied patches 1 and 2, and while 2 had a conflict I could resolve
> easily I don't trust myself to fix the conflicts in patch 3 correctly...
> 
> It's conflicting with Karl's VHT handling fix in this area that I just
> applied.
> 
In fact v1 was already conflicting with the tip of the tree (@5253ffb
with the basic rates fix), I didn't think it was worth reporting in
patch 3/5 feedback as I supposed Felix would base v2 on the tip of tree.
 
Karl
