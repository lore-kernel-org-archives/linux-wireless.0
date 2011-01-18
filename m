Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35023 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1ARCmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 21:42:50 -0500
Received: by qwa26 with SMTP id 26so5409385qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 18:42:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101181006.17322.br1@einfach.org>
References: <20110117043728.8024.13541.stgit@localhost6.localdomain6>
	<AANLkTinx+wFDFnDrxrBS5T=RqvZgRLxFOeeibrLxorde@mail.gmail.com>
	<201101181006.17322.br1@einfach.org>
Date: Mon, 17 Jan 2011 21:42:49 -0500
Message-ID: <AANLkTi=SbkiZE0-5bJ+jraMhCMbvyaF=L0HOq5o0LtyJ@mail.gmail.com>
Subject: Re: [PATCH 2] cfg80211: Extend channel to frequency mapping for 802.11j
From: Brian Prodoehl <bprodoehl@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	gwingerde@gmail.com, dcbw@redhat.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 17, 2011 at 8:06 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Tue January 18 2011 05:17:31 Brian Prodoehl wrote:
>> Yeah, looks good.  Is it worth noting that none of the drivers
>> actually support the 802.11j channels yet?
>
> I am already using it locally in ath5k. I have it working in 4.9GHz, but i'm
> not exactly sure in which cases i can enable the 4.9GHz channels. I will send
> patches after the mac80211 part got merged.

I have it working in ath9k, as well.  iw needs the same tweak to
ieee80211_channel_to_frequency.  Where do patches to iw get submitted?

>> Not sure of the format of
>> follow-up s-o-b's, so here goes...
>>
>> Signed-off-by: Brian Prodoehl <bprodoehl@gmail.com>
>
> Not sure, either, but i hope John will pick it up. Thanks!
>
> bruno
>
