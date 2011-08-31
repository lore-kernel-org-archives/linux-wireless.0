Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59160 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab1HaNta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 09:49:30 -0400
Received: by ewy4 with SMTP id 4so413968ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 06:49:28 -0700 (PDT)
From: Alexander Simon <an.alexsimon@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/4] nl80211: Parse channel type attribute in an IBSS join request
Date: Wed, 31 Aug 2011 15:49:25 +0200
Message-ID: <2366540.2f8oa1FYLX@alex-1> (sfid-20110831_154933_329735_06219035)
In-Reply-To: <1314772577.4161.12.camel@jlt3.sipsolutions.net>
References: <2053881.ENil2Dy3QM@alex-1> <1314772577.4161.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Use for what? That's confusing. You're asking if it can be used for
> beaconing, as the old function name *clearly* said. Now you're making it
> confusing.
I'm not only asking for beaconing. In 4/4, i am using this function to see if 
regdom allows me to use HT40 on the extension channel (beacons and data 
traffic). Hence can_use_ext_chan.

Even cfg80211_set_freq in net/wireless/chan.c uses this to see if we can 
communicate (see printk) on that channel.

So my suggestion would be to use that name. But I'd also use the old if 
preferred.

Alex
