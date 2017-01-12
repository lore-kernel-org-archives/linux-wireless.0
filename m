Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34181 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdALTFJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 14:05:09 -0500
Received: by mail-qt0-f195.google.com with SMTP id a29so3532948qtb.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2017 11:05:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com>
References: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com>
From: Dave Taht <dave.taht@gmail.com>
Date: Thu, 12 Jan 2017 11:05:03 -0800
Message-ID: <CAA93jw7PN+5Uinyp4JPd8XTd=F_ZFRKTD9SMEm_JVP2iuJDLxA@mail.gmail.com> (sfid-20170112_200518_858670_2F269A6E)
Subject: Re: [PATCH] mac80211: prevent skb/txq mismatch
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yay! This sounds like a potential fix for this?

https://bugs.lede-project.org/index.php?do=details&task_id=368

Are all the ath10k chipsets excluded by commit:

4ca1807815aa6801aaced7fdefa9edacc2521767

Still needed to be excluded?
