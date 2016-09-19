Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49932 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754238AbcISJAn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 05:00:43 -0400
Message-ID: <1474275637.4469.15.camel@sipsolutions.net> (sfid-20160919_110047_833948_6AC615FC)
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
From: Johannes Berg <johannes@sipsolutions.net>
To: "Pedersen, Thomas" <twp@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 19 Sep 2016 11:00:37 +0200
In-Reply-To: <1474050629.31554.19.camel@qca.qualcomm.com> (sfid-20160916_203211_452910_08E25A89)
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
         <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>
         <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com>
         <1473662637.4201.2.camel@sipsolutions.net>
         <1473789454.27738.7.camel@qca.qualcomm.com>
         <1473789740.5622.3.camel@sipsolutions.net>
         <1474050629.31554.19.camel@qca.qualcomm.com>
         (sfid-20160916_203211_452910_08E25A89)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Actually, can you apply the v2 (cfg80211: add bitrate for 20MHz MCS
> 9) of this? Systems guys confirmed they use MCS 9 @ 20MHz when LDPC
> is enabled. Also confirmed bitrate should be ok.

I don't really understand that. How can the bitrate be "OK" when the
spec explicitly says it cannot be used?

johannes
