Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52024 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdKFK3b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 05:29:31 -0500
Message-ID: <1509964164.2669.0.camel@sipsolutions.net> (sfid-20171106_112934_815215_A5133DCF)
Subject: Re: [PATCH] mac80211: Update last_ack status for all except probing
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Date: Mon, 06 Nov 2017 11:29:24 +0100
In-Reply-To: <1509409746-26592-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1509409746-26592-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-30 at 17:29 -0700, Rajkumar Manoharan wrote:
> Update last_ack status for all except station probing frames
> (i.e null data). Otherwise the station inactivity duration is
> cleared whenever AP is checking presence of idle stations by sending
> null data frame for every inactive threshold (ap_max_inactivity).

You make it sound like this is a problem, but don't explain why it
would be? I don't really see it anyway.

johannes
