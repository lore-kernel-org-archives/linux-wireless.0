Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50659 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755413AbcJMMwR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 08:52:17 -0400
Message-ID: <1476363127.4904.25.camel@sipsolutions.net> (sfid-20161013_145240_825718_568956FC)
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "Pedersen, Thomas" <twp@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 13 Oct 2016 14:52:07 +0200
In-Reply-To: <7cc8610d-453d-1611-6c60-581ca7b68346@candelatech.com>
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
         <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>
         <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com>
         <1473662637.4201.2.camel@sipsolutions.net>
         <1473789454.27738.7.camel@qca.qualcomm.com>
         <1473789740.5622.3.camel@sipsolutions.net>
         <1474050629.31554.19.camel@qca.qualcomm.com>
         <1474275637.4469.15.camel@sipsolutions.net>
         <57E01026.9030604@candelatech.com>
         <1475573532.5324.47.camel@sipsolutions.net>
         <7cc8610d-453d-1611-6c60-581ca7b68346@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> If the firmware/NIC is putting it on air at a particular encoding,
> then I think the stack should report it exactly as it is on air if
> possible.

It already does. We're only debating what bitrate to report :P

Anyway, I don't have the latest patch anymore - somebody please resend
it.

johannes
