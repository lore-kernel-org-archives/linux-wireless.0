Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18881 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753081AbdCTP3C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 11:29:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6kl: Remove old 802.11a-only channels
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <CAPXt_dabk8KNL0HTHZJfoHT+93ZS+3R31tVEPb4zpKJWE65cMw@mail.gmail.com>
References: <CAPXt_dabk8KNL0HTHZJfoHT+93ZS+3R31tVEPb4zpKJWE65cMw@mail.gmail.com>
To: Rostyslav Khudolii <rkhudolii@airtame.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Attila Sukosd" <attila@airtame.com>
Message-ID: <e1806067c6fb4837b76d9b799e93c802@euamsexm01a.eu.qualcomm.com> (sfid-20170320_163209_149681_E3B81B2A)
Date: Mon, 20 Mar 2017 16:28:53 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rostyslav Khudolii <rkhudolii@airtame.com> wrote:
> Channels 34/38/42/46 can only be used for compatibility with old devices sold
> in Japan. Modern products, such as AR6003/AR6004 don't support these channels.
> Keeping them in the upstream is error prone and requires full network stack
> support.  A custom patch should be used in case such compatibility is required.
> 
> Without this one, a user is able to start an AP using wpa_supplicant, for
> example, on one of these channels (34/38/42/46), without getting any
> warning/error from the cfg80211 or ath6kl - which is correct (since these
> channels match regdom rules). However, the AR6003 and its firmware (we're using
> v3.4.0.225) will fail and return "WMI_CMDERROR_EVENTID" with "INVALID_PARAM"
> error code.
> 
> Signed-off-by: Rostyslav Khudolii <rkhudolii@airtame.com>
> Cc: Attila Sukosd <attila@airtame.com>

Patch applied to ath-next branch of ath.git, thanks.

b51040fc375c ath6kl: Remove old 802.11a-only channels

-- 
https://patchwork.kernel.org/patch/9615199/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
