Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52252 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753135AbeADOuC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 09:50:02 -0500
Message-ID: <1515077400.10342.26.camel@sipsolutions.net> (sfid-20180104_155005_667089_78404E74)
Subject: Re: [PATCH v2 3/3] nl80211: Introduce scan flags to emphasize
 requested scan behavior
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Sunil Dutt <usdutt@qti.qualcomm.com>
Date: Thu, 04 Jan 2018 15:50:00 +0100
In-Reply-To: <1513960419-24780-3-git-send-email-jouni@qca.qualcomm.com>
References: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com>
         <1513960419-24780-3-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-22 at 18:33 +0200, Jouni Malinen wrote:
> From: Sunil Dutt <usdutt@qti.qualcomm.com>
> 
> This commit defines new scan flags (LOW_SPAN, LOW_POWER, HIGH_LATENCY)
> to emphasize the requested scan behavior for the driver. These flags are
> optional and are mutually exclusive. The implementation of the
> respective functionality can be driver/hardware specific.
> 
> These flags can be used to control the compromise between how long a
> scan takes, how much power it uses, and high accurate/complete the scan
> is in finding the BSSs.
> 
> Signed-off-by: Sunil Dutt <usdutt@qti.qualcomm.com>
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---
>  include/uapi/linux/nl80211.h | 28 +++++++++++++++++++++++++++-
>  net/wireless/nl80211.c       | 13 +++++++++++--
>  2 files changed, 38 insertions(+), 3 deletions(-)
> 
> v2:
> - added driver capability flags to indicate which of the options are
>   supported
> - added to this patch series due to a new dependency in one of the
>   header files

Looks fine, but I guess I should wait for a rebase.

johannes
