Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:34824 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYFIRnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 13:43:41 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1383832ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 10:43:35 -0700 (PDT)
Subject: Re: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213032085.22220.1.camel@johannes.berg>
References: <1212774671.6340.75.camel@brick>
	 (sfid-20080606_195944_782545_6A2B1449)  <1212997265.698.55.camel@johannes.berg>
	 <1213029086.5974.21.camel@brick>
	 (sfid-20080609_183129_796413_B211C17A)  <1213032085.22220.1.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 10:43:32 -0700
Message-Id: <1213033412.5974.28.camel@brick> (sfid-20080609_194346_304557_A531E565)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-09 at 19:21 +0200, Johannes Berg wrote:
> On Mon, 2008-06-09 at 09:31 -0700, Harvey Harrison wrote:
> > 
> > As this helper only checks for the one bit being set, I chose _has_.
> 
> Hmm. As far as I can tell, it checks that the frame is a QoS controlled
> data frame. Hence, it explicitly checks that it _is_ a data frame and
> _has_ the QoS bit, but in 802.11 lingo I think that means it _is_ a
> "data+qos" frame.
> 

Well, it's not a big deal...what name do you want and I'll change it.

Harvey

