Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bugs.comnets.uni-bremen.de ([134.102.186.10]:63132 "EHLO
	bugs.comnets.uni-bremen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820AbYEUHII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 03:08:08 -0400
Date: Wed, 21 May 2008 09:08:05 +0200 (CEST)
From: Markus Becker <mab@comnets.uni-bremen.de>
To: Dan Williams <dcbw@redhat.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: mrv8k: now gets scan results
In-Reply-To: <1211312013.10737.10.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0805210900160.3750@bugs.comnets.uni-bremen.de> (sfid-20080521_090812_084000_3923C301)
References: <1211312013.10737.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

I just tested it and my Option Fusion+ HSDPA card does not scan:

May 21 08:52:17 shelbyville kernel: Command timeout
May 21 08:52:17 shelbyville kernel: Could not set channel
May 21 08:52:17 shelbyville kernel: ~Failed to set channel
May 21 08:52:17 shelbyville kernel: wlan1: failed to set freq to 2417 MHz for scan
May 21 08:52:19 shelbyville kernel: Command timeout
May 21 08:52:19 shelbyville kernel: Could not set channel
May 21 08:52:19 shelbyville kernel: ~Failed to set channel
May 21 08:52:19 shelbyville kernel: wlan1: failed to set freq to 2422 MHz for scan
[...]

I also got some lockups, however I have no infrastructure setup to debug 
those.

Thanks for all your efforts,
Markus

On Tue, 20 May 2008, Dan Williams wrote:

> Hi,
>
> I've gotten mrv8k to the point where I can get scan results with it on
> my 3COM 3CRGPC10075 CardBus card.  Data RX still doesn't work for some
> reason and WEP associations still fail with a mac80211 timeout.  Enough
> for today though.  All changes pushed to mrv8k.git on infradead.
>
> Dan
>
>
