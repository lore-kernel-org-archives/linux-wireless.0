Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39181 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DINca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 09:32:30 -0400
Date: Mon, 9 Apr 2012 08:32:19 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: brcmsmac on BCM47XX SoCs
Message-ID: <20120409133219.GB20916@thinkpad-t410> (sfid-20120409_153234_202599_D5F2A29D)
References: <4F7F71A2.40105@hauke-m.de>
 <4F815181.6030007@broadcom.com>
 <CACna6rzSsQXxyMTX+-UJ-BuJ671avs8dVPOnOc1kSRW-3URvQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzSsQXxyMTX+-UJ-BuJ671avs8dVPOnOc1kSRW-3URvQg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 08, 2012 at 09:54:31PM +0200, Rafał Miłecki wrote:
> 2012/4/8 Arend van Spriel <arend@broadcom.com>:
> > On 04/06/2012 11:43 PM, Hauke Mehrtens wrote:
> >> What are your plans to support phy_ht in brcmsmac, for now it is just
> >> supported by b43?
> >
> >
> > I have not been paying good attention to community feedback on b43 phy_ht
> > support. As b43 support bcm4331 with that phy we decided to stay clear from
> > that device. We are to add new phy code for new devices. Not sure if that
> > includes the phy_ht.
> 
> Whoops, that's extremely too bad. HT support is really wanted for a
> lot of routers. What we have in b43 is support coming from watching
> mmio ops only, there is no way for it to be complete. I believe you
> really should think and releasing HT PHY code, a lot of ppl will be
> interested in that.

I second this. Besides routers, some recent MacBooks use bcm4331 and
lack support for HT or for the 5 GHz band. Plus on the model I'm working
with at least (MacBook Pro 8,2) Tx stops working completely after S3
unless b43 and bcma are reloaded, and I haven't had any luck finding a
fix for it.

Seth

