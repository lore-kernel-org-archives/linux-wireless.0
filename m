Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:11047 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbZBTAiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 19:38:03 -0500
Received: by yx-out-2324.google.com with SMTP id 8so277253yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 16:38:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1235050014.4023.62.camel@johannes.local>
References: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
	 <1234999545-14357-11-git-send-email-lrodriguez@atheros.com>
	 <1235050014.4023.62.camel@johannes.local>
Date: Thu, 19 Feb 2009 16:38:00 -0800
Message-ID: <43e72e890902191638k3549b0dfic0bb209548915073@mail.gmail.com> (sfid-20090220_013808_228485_B871C022)
Subject: Re: [PATCH v4 10/15] cfg80211: remove likely from an 11d hint case
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 19, 2009 at 5:26 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-02-18 at 18:25 -0500, Luis R. Rodriguez wrote:
>
>> +     if (unlikely(WARN_ON(reg_same_country_ie_hint(wiphy, checksum))))
>>               goto out;
>
> WARN_ON already contains an unlikely.

Thanks! I'll go fix.
