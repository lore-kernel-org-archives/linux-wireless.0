Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:17650 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753385Ab1ARCuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 21:50:08 -0500
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0840279004
	for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 11:50:06 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Brian Prodoehl <bprodoehl@gmail.com>
Subject: Re: [PATCH 2] cfg80211: Extend channel to frequency mapping for 802.11j
Date: Tue, 18 Jan 2011 11:50:15 +0900
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	gwingerde@gmail.com, dcbw@redhat.com,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com
References: <20110117043728.8024.13541.stgit@localhost6.localdomain6> <201101181006.17322.br1@einfach.org> <AANLkTi=SbkiZE0-5bJ+jraMhCMbvyaF=L0HOq5o0LtyJ@mail.gmail.com>
In-Reply-To: <AANLkTi=SbkiZE0-5bJ+jraMhCMbvyaF=L0HOq5o0LtyJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101181150.15936.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue January 18 2011 11:42:49 Brian Prodoehl wrote:
> On Mon, Jan 17, 2011 at 8:06 PM, Bruno Randolf <br1@einfach.org> wrote:
> > On Tue January 18 2011 05:17:31 Brian Prodoehl wrote:
> >> Yeah, looks good.  Is it worth noting that none of the drivers
> >> actually support the 802.11j channels yet?
> > 
> > I am already using it locally in ath5k. I have it working in 4.9GHz, but
> > i'm not exactly sure in which cases i can enable the 4.9GHz channels. I
> > will send patches after the mac80211 part got merged.
> 
> I have it working in ath9k, as well.  

Good to hear. Do you have any information on when we can enable these 
frequencies? I'm not sure all cards are calibrated for 4.9GHz. Any info about 
this from Atheros, Luis?

> iw needs the same tweak to
> ieee80211_channel_to_frequency.  Where do patches to iw get submitted?

I was waiting with positng the iw part until the mac80211 patch is accepted 
and merged. It should also posted on this list and cc johannes.

bruno
