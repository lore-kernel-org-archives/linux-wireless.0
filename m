Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32806 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966472AbdAKNPR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 08:15:17 -0500
Message-ID: <1484140514.29931.4.camel@sipsolutions.net> (sfid-20170111_141741_166856_C057863F)
Subject: Re: [PATCH] cfg80211: wext does not need to set monitor channel in
 managed mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
Cc: linux-wireless@vger.kernel.org, daniel.lezcano@linaro.org,
        daniel.thompson@linaro.org
Date: Wed, 11 Jan 2017 14:15:14 +0100
In-Reply-To: <1483971949-10014-1-git-send-email-jorge.ramirez-ortiz@linaro.org> (sfid-20170109_152601_854161_50F0F778)
References: <1483971949-10014-1-git-send-email-jorge.ramirez-ortiz@linaro.org>
         (sfid-20170109_152601_854161_50F0F778)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-01-09 at 15:25 +0100, Jorge Ramirez-Ortiz wrote:
> There is not a valid reason to attempt setting the monitor channel
> while in managed mode. Since this code path only deals with this
> mode,
> remove the code block.
> 
Applied.

johannes
