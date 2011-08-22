Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:54991 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab1HVOMV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 10:12:21 -0400
Date: Mon, 22 Aug 2011 16:12:16 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Pierre Louis Aublin <pierre-louis.aublin@inria.fr>
Cc: Bing Zhao <bzhao@marvell.com>, kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/net/wireless/mwifiex/scan.c: test the
 just-initialized value
In-Reply-To: <4E52638C.8080407@inria.fr>
Message-ID: <Pine.LNX.4.64.1108221612090.10948@ask.diku.dk> (sfid-20110822_161239_664279_1BBE5297)
References: <1314021636-11528-4-git-send-email-julia@diku.dk>
 <4E52638C.8080407@inria.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 22 Aug 2011, Pierre Louis Aublin wrote:

> Hello all
> 
> On 08/22/2011 04:00 PM, Julia Lawall wrote:
> > -	if (!bss_desc) {
> > +	if (!beacon_ie) {
> >     dev_err(priv->adapter->dev, " failed to alloc bss_desc\n");
> Shouldn't we also modify the error message, from "failed to alloc bss_desc" to
> "failed to alloc beacon_ie" ?

Sure :)

julia
