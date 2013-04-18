Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:61847 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3DRNOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 09:14:47 -0400
Received: by mail-ea0-f173.google.com with SMTP id k11so1227169eaj.4
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 06:14:46 -0700 (PDT)
Date: Thu, 18 Apr 2013 15:10:37 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2 2/2] mac80211: minstrel_ht: initialize rates selection
Message-ID: <20130418131037.GE8638@magnum.frso.rivierawaves.com> (sfid-20130418_151452_596232_9CA1C948)
References: <1366287981-24134-1-git-send-email-karl.beldan@gmail.com>
 <1366287981-24134-2-git-send-email-karl.beldan@gmail.com>
 <20130418124050.GD8638@magnum.frso.rivierawaves.com>
 <516FEF43.2030404@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <516FEF43.2030404@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 18, 2013 at 03:04:03PM +0200, Felix Fietkau wrote:
> On 2013-04-18 2:40 PM, Karl Beldan wrote:
> > Johannes, Felix,
> > 
> > This seems to me like an important enough issue to IMHO, make it into
> > 3.9/-stable. But since we only have a few days before Linus tags the 3.9
> > I understand the boldness of the thought.
> I'm not sure it's important enough for 3.9. Is disabling MCS0 really
> that common?
> 
Right.
 
Karl
