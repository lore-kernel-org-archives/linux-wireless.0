Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f174.google.com ([209.85.210.174]:33444 "EHLO
        mail-wj0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbcLGUD1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 15:03:27 -0500
Received: by mail-wj0-f174.google.com with SMTP id xy5so371059263wjc.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 12:03:26 -0800 (PST)
Subject: Re: [PATCH v2 2/2] cfg80211: Add support to sched scan to report
 better BSSs
To: "Vamsi, Krishna" <vamsin@qti.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>
References: <1480715949-20169-1-git-send-email-jouni@qca.qualcomm.com>
 <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
 <1481102727.4092.34.camel@sipsolutions.net>
 <dc960243db2b452f97721dad49f0a63b@aphydexm01b.ap.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <280cb669-2360-d4fc-779b-80196c944e2e@broadcom.com> (sfid-20161207_210330_806615_F1B34F3C)
Date: Wed, 7 Dec 2016 21:03:23 +0100
MIME-Version: 1.0
In-Reply-To: <dc960243db2b452f97721dad49f0a63b@aphydexm01b.ap.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7-12-2016 10:33, Vamsi, Krishna wrote:
>> -----Original Message-----
>> From: Johannes Berg [mailto:johannes@sipsolutions.net]
> 
>> What about Arend's comment regarding this functionality overlapping with the
>> BSS selection offload configuration?
>>
>> Do you think there's any ability to share attributes/functionality?
> 
> Hi Johannes,
> 
> I think the later comment from Luca on this which I pasted below is more agreeable.
> 
> Yes, similar but not quite the same.  The existing case is for finding BSSs that are worth waking the host up for (while disconnected), so it needs to be better than the RSSI passed (absolute number).  Now this is about relative RSSI as compared to the current connection, so RELATIVE_RSSI is different than RSSI and I think the same attribute should not be used, to avoid confusion.

I noticed the response from Luca, but did not get back on this. I know
it is not the same, but what I meant is whether we could extend it so it
also covers your scenario.

Regards,
Arend
