Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:56240 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbeIFLIG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 07:08:06 -0400
Message-ID: <1536215640.4015.0.camel@sipsolutions.net> (sfid-20180906_083414_445405_E0FB50E0)
Subject: Re: [PATCH v3 0/3] support ftm responder configuration/statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, david.spinadel@intel.com
Date: Thu, 06 Sep 2018 08:34:00 +0200
In-Reply-To: <1536195700-1351-1-git-send-email-pradeepc@codeaurora.org>
References: <1536195700-1351-1-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-05 at 18:01 -0700, Pradeep Kumar Chitrapu wrote:
> Currently ftm_responder parameter in hostapd.conf is only used for fine
> timing measurement (FTM) capability advertisement and actual control of
> the functionality is with low-level device/driver. This leads to confusion
> to the user when the capability advertisement is different from actual FTM
> responder functionality.
> 
> For example, FTM responder capability advertisement is set to 'enabled',
> but the functionality is disabled or not supported by the driver.
> 
> The patch set allows userspace to enable FTM responder functionality
> with the addition of new Netlink flag attribute NL80211_ATTR_FTM_RESPONDER
> with configurable lci/civic ocation parameters. Also extended feature flag
> is added for the drivers to advertise the support. Setting the flag to
> enable FTM responder would imply that AP responds to all FTM requests.
> Default is considered to be disabled.
> 
> changes in V3:
>  - fixed the ambiguous ftm responder disable case to be not supported

For reasons unknown to me, this patchset made it neither to the list
nor, consequently, patchwork. Please resend.

johannes
