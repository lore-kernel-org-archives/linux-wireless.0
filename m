Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36653 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932768AbcIXSGt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Sep 2016 14:06:49 -0400
Received: by mail-oi0-f67.google.com with SMTP id i193so10989066oib.3
        for <linux-wireless@vger.kernel.org>; Sat, 24 Sep 2016 11:06:49 -0700 (PDT)
Subject: Re: [PATCH 2/2] rtlwifi: Add explicit values to hw_variables enum
To: Joe Perches <joe@perches.com>, kvalo@codeaurora.org
References: <1474736239-9826-1-git-send-email-Larry.Finger@lwfinger.net>
 <1474736239-9826-3-git-send-email-Larry.Finger@lwfinger.net>
 <1474738987.23838.13.camel@perches.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e2f60a69-0804-083f-289f-cb869edd6de3@lwfinger.net> (sfid-20160924_200652_950736_892A7386)
Date: Sat, 24 Sep 2016 13:06:46 -0500
MIME-Version: 1.0
In-Reply-To: <1474738987.23838.13.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2016 12:43 PM, Joe Perches wrote:
> On Sat, 2016-09-24 at 11:57 -0500, Larry Finger wrote:
>> The entries in this enum may be referenced in debug output. Adding explicit
>> values simplifies the lookup.
>
> A negative aspect to this style is forced renumbering
> if a HW_VAR entry is inserted.
>
> Is that possible?

Any new one would be added at the end.

Larry
