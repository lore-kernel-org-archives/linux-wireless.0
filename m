Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10912 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbcIGSUd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 14:20:33 -0400
From: "Pedersen, Thomas" <twp@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
Date: Wed, 7 Sep 2016 18:20:28 +0000
Message-ID: <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com> (sfid-20160907_202037_425266_BCC76D19)
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
 <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>
In-Reply-To: <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2016 12:07 PM, Ben Greear wrote:
> On 09/06/2016 12:00 PM, Thomas Pedersen wrote:
>> Some drivers (ath10k) report MCS 9 @ 20MHz, which
>> technically isn't allowed. To get more meaningful value
>> than 0 out of this however, just cap the bitrate for 20MHz
>> to MCS 8.
>
> If it is actually reporting MCS9, why lie about it?  Report it up
> the stack as a proper value instead of hiding the issue?

Good point, will send a v2 extrapolating the value to 86.5Mb/s.

--=20
thomas=
