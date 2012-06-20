Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:42466 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab2FTJDc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:03:32 -0400
Message-ID: <4FE191E1.2020000@tieto.com> (sfid-20120620_110335_372728_79770584)
Date: Wed, 20 Jun 2012 11:03:29 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFCv2 03/13] cfg80211: add channel tracking for AP and mesh
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>  <1340172859-18146-4-git-send-email-michal.kazior@tieto.com> <1340180293.4655.24.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340180293.4655.24.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
>> We need to know which channel is used by a running
>> AP and mesh for channel context accounting and
>> finding matching/active interface combination.
>
> I think there's the AP channel change function now that full-MAC drivers
> can call -- need to update there?

I'm not aware of that. I thought it's impossible to change a channel 
while AP is running now. Am I missing something?

But actually there's a bug. I forgot about the libertas set_channel for 
mesh workaround. I'll address that later.


-- 
Pozdrawiam / Best regards, Michal Kazior.
