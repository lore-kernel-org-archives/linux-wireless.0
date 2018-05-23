Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932070AbeEWMpb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 08:45:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 23 May 2018 18:15:30 +0530
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: bpothuno@qti.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] iw: avgerage ack rssi changes for data frames
In-Reply-To: <1527069635.3759.17.camel@sipsolutions.net>
References: <1520493581-26708-1-git-send-email-bpothuno@codeaurora.org>
 <1527069635.3759.17.camel@sipsolutions.net>
Message-ID: <003d530439e0c92b235dc93db3828055@codeaurora.org> (sfid-20180523_144535_278351_1C2B8FE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sure Johannes, I will send another version of patch.

On 2018-05-23 15:30, Johannes Berg wrote:
> On Thu, 2018-03-08 at 12:49 +0530, Balaji Pothunoori wrote:
>> This patch is to display the average ack rssi for data
>> frames. "avg ack signal" field diplay limited by host based on
>> firmware capablities.
> 
> This doesn't compile, please respin (and you could fix the "average"
> typo in the subject)
> 
> johannes
