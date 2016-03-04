Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34371 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759021AbcCDJNa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 04:13:30 -0500
Message-ID: <1457082805.2333.0.camel@sipsolutions.net> (sfid-20160304_101416_998974_8C9F5453)
Subject: Re: [PATCH V11 1/2] nl80211: add feature for BSS selection support
From: Johannes Berg <johannes@sipsolutions.net>
To: arend@broadcom.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 04 Mar 2016 10:13:25 +0100
In-Reply-To: <56D8A618.4050707@broadcom.com> (sfid-20160303_220118_206425_01EF95D1)
References: <1456947439-28968-1-git-send-email-arend@broadcom.com>
	 <1457020529.2044.31.camel@sipsolutions.net> <56D8A618.4050707@broadcom.com>
	 (sfid-20160303_220118_206425_01EF95D1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-03 at 22:01 +0100, Arend Van Spriel wrote:
> 
> On 3-3-2016 16:55, Johannes Berg wrote:
> > On Wed, 2016-03-02 at 20:37 +0100, Arend van Spriel wrote:
> > > Introducing a new feature that the driver can use to
> > > indicate the driver/firmware supports configuration of BSS
> > > selection criteria upon CONNECT command. This can be useful
> > > when multiple BSS-es are found belonging to the same ESS,
> > > ie. Infra-BSS with same SSID. The criteria can then be used to
> > > offload selection of a preferred BSS.
> > > 
> > Applied, finally :)
> > 
> > I moved the wiphy supported methods check into parse_bss_select()
> > to
> > avoid the double error path in the caller, plus some editorial
> > changes.
> 
> Do you expect Kalle to take the brcmfmac patch or can it go through
> your tree?
> 

I was expecting Kalle to apply it.

johannes
