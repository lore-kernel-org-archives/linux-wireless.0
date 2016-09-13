Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37953 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754638AbcIMSC1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 14:02:27 -0400
Message-ID: <1473789740.5622.3.camel@sipsolutions.net> (sfid-20160913_200230_112754_D6C0AE8F)
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
From: Johannes Berg <johannes@sipsolutions.net>
To: "Pedersen, Thomas" <twp@qca.qualcomm.com>,
        Ben Greear <greearb@candelatech.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 13 Sep 2016 20:02:20 +0200
In-Reply-To: <1473789454.27738.7.camel@qca.qualcomm.com>
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
         <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>
         <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com>
         <1473662637.4201.2.camel@sipsolutions.net>
         <1473789454.27738.7.camel@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Yeah so apparently the overhead involved in 256-QAM 5/6 (MCS 9)
> results in lower effective bitrate than just using MCS 8 (unless
> you're using 3 spatial streams).

Ah. I took a - very brief - look at why this one is invalid and
couldn't figure it out.

>  Sounds like a rate control or reporting bug then.
> Please drop this.
> 
Ok, thanks.

johannes
