Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33854 "EHLO
        mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbcISJcM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 05:32:12 -0400
Received: by mail-pa0-f46.google.com with SMTP id wk8so46944122pab.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2016 02:32:11 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
To: Johannes Berg <johannes@sipsolutions.net>,
        "Pedersen, Thomas" <twp@qca.qualcomm.com>
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
 <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>
 <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com>
 <1473662637.4201.2.camel@sipsolutions.net>
 <1473789454.27738.7.camel@qca.qualcomm.com>
 <1473789740.5622.3.camel@sipsolutions.net>
 <1474050629.31554.19.camel@qca.qualcomm.com>
 <1474275637.4469.15.camel@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <36dc877c-1c80-561a-4fd9-bae629b982b3@broadcom.com> (sfid-20160919_113216_967423_64625A79)
Date: Mon, 19 Sep 2016 11:31:55 +0200
MIME-Version: 1.0
In-Reply-To: <1474275637.4469.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 19-9-2016 11:00, Johannes Berg wrote:
> 
>> Actually, can you apply the v2 (cfg80211: add bitrate for 20MHz MCS
>> 9) of this? Systems guys confirmed they use MCS 9 @ 20MHz when LDPC
>> is enabled. Also confirmed bitrate should be ok.
> 
> I don't really understand that. How can the bitrate be "OK" when the
> spec explicitly says it cannot be used?

This conversation sounds a lot like these two threads [1] and [2]. Just
not sure if our vendor specific IEs cover this rate as well.

Regards,
Arend

[1]
http://mid.gmane.org/1457633336-27898-1-git-send-email-greearb@candelatech.com
[2] 1461244669-19871-1-git-send-email-kvalo@qca.qualcomm.com
