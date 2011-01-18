Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:41044 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753127Ab1ARBGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 20:06:09 -0500
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0768152766
	for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 10:06:07 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Brian Prodoehl <bprodoehl@gmail.com>
Subject: Re: [PATCH 2] cfg80211: Extend channel to frequency mapping for 802.11j
Date: Tue, 18 Jan 2011 10:06:17 +0900
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	gwingerde@gmail.com, dcbw@redhat.com,
	linux-wireless@vger.kernel.org
References: <20110117043728.8024.13541.stgit@localhost6.localdomain6> <AANLkTinx+wFDFnDrxrBS5T=RqvZgRLxFOeeibrLxorde@mail.gmail.com>
In-Reply-To: <AANLkTinx+wFDFnDrxrBS5T=RqvZgRLxFOeeibrLxorde@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101181006.17322.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue January 18 2011 05:17:31 Brian Prodoehl wrote:
> Yeah, looks good.  Is it worth noting that none of the drivers
> actually support the 802.11j channels yet?  

I am already using it locally in ath5k. I have it working in 4.9GHz, but i'm 
not exactly sure in which cases i can enable the 4.9GHz channels. I will send 
patches after the mac80211 part got merged.

> Not sure of the format of
> follow-up s-o-b's, so here goes...
> 
> Signed-off-by: Brian Prodoehl <bprodoehl@gmail.com>

Not sure, either, but i hope John will pick it up. Thanks!

bruno
