Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45174 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751057AbeAVMWK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:22:10 -0500
Message-ID: <1516623728.2508.4.camel@sipsolutions.net> (sfid-20180122_132214_593582_43D648DB)
Subject: Re: [PATCH 1/2] cfg80211: Add tx ack signal attribute in sta info
From: Johannes Berg <johannes@sipsolutions.net>
To: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Date: Mon, 22 Jan 2018 13:22:08 +0100
In-Reply-To: <1516279208-16485-1-git-send-email-vnaralas@codeaurora.org>
References: <1516279208-16485-1-git-send-email-vnaralas@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-01-18 at 18:10 +0530, Venkateswara Naralasetty wrote:
> From: Bhagavathi Perumal S <bperumal@codeaurora.org>
> 
> This patch provides support for users to get ack signal
> strength of last transmitted by introducing new attribute
> 'NL80211_STA_INFO_ACK_SIGNAL'.

No real objection to the patch itself, but you should say *why* you
need this, and I'm not really sure I see much point in having the
signal strength of the very last ACK frame?

At least provide reasoning so other drivers can decide whether to
implement it or not.

> + * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK frame(u8, dBm)

more like s8, really.

johannes
