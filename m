Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:37850 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab3CQV2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 17:28:37 -0400
Received: by mail-wg0-f41.google.com with SMTP id ds1so1968664wgb.4
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2013 14:28:36 -0700 (PDT)
Date: Sun, 17 Mar 2013 22:28:30 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [RFC 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
Message-ID: <20130317212830.GB6886@gobelin> (sfid-20130317_222840_793008_1671707D)
References: <1363552234-6752-1-git-send-email-karl.beldan@gmail.com>
 <1363552234-6752-2-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363552234-6752-2-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 17, 2013 at 09:30:33PM +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Drivers that don't use chanctxes cannot perform VHT association because
> they still use a "backward compatibility" pair of {ieee80211_channel,
> nl80211_channel_type} in ieee80211_conf and ieee80211_local.
> (FIXME: this only changes mac80211_hwsim for the RFC)
> 
I forgot the monitor part (I thought I would not miss a part from what
I've been using at work, sorry), anyways I'll wait for your feedback
before adjusting that.

 
Karl
