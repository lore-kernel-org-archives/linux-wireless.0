Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62023 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab3KLOrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 09:47:21 -0500
Received: by mail-wi0-f174.google.com with SMTP id cb5so3784110wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 06:47:20 -0800 (PST)
Date: Tue, 12 Nov 2013 15:46:58 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [RFC 1/2] mac80211: minstrel_ht: add basic support for VHT rates
 <= 80MHz
Message-ID: <20131112144658.GC22775@magnum.frso.rivierawaves.com> (sfid-20131112_154745_149751_8AD7DE0C)
References: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 12, 2013 at 03:30:24PM +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Helps feel current minstrel and stack rate-control API limits.
> Helped trigger some bugs in vht tx code path in the past.
> Some ppl were interested in checking that out.
> some TODOs:
> - Optimize rate-indexes loops and sampling holes
> - The txinfo flags for vht STAs
> 
> VHT rates support depends on a new CONFIG_MAC80211_RC_MINSTREL_VHT.
> 
This relies on
[mac80211: minstrel_ht: replace some occurences of MCS_GROUP_RATES]
http://marc.info/?l=linux-wireless&m=138418939213230&w=2
 
Karl
