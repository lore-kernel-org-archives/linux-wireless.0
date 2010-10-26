Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:3385 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755655Ab0JZChM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 22:37:12 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-041153628
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 11:37:09 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] iw: Add ibss join parameter for beacon interval
Date: Tue, 26 Oct 2010 11:37:10 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20101019073141.14128.29518.stgit@localhost6.localdomain6> <1287995176.3587.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1287995176.3587.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010261137.10753.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon October 25 2010 17:26:16 Johannes Berg wrote:
> On Tue, 2010-10-19 at 16:31 +0900, Bruno Randolf wrote:
> > +	if (argc > 1 && strcmp(argv[0], "bintval") == 0) {
> 
> I'd prefer this to be called just "bi" or fully spelt out.

o.k.
 
> >  	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
> >  	"Leave the current IBSS cell.");
> >  
> >  COMMAND(ibss, join,
> > 
> > -	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] "
> > +	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [bintval <ms>] "
> 
> It's not in ms, but TU. *sigh*

oh, true. i forgot. will change.

bruno
