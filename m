Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35614 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730920AbeGVVAl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Jul 2018 17:00:41 -0400
Message-ID: <1532289708.3680.3.camel@sipsolutions.net> (sfid-20180722_220349_111217_4FB739FC)
Subject: Re: [PATCH 11/20] wil6210: send L2UF on behalf of newly associated
 station
From: Johannes Berg <johannes@sipsolutions.net>
To: Maya Erez <merez@codeaurora.org>, Kalle Valo <kvalo@codeaurora.org>
Cc: Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Date: Sun, 22 Jul 2018 22:01:48 +0200
In-Reply-To: <1532245665-15249-12-git-send-email-merez@codeaurora.org> (sfid-20180722_095029_900823_BD03869E)
References: <1532245665-15249-1-git-send-email-merez@codeaurora.org>
         <1532245665-15249-12-git-send-email-merez@codeaurora.org>
         (sfid-20180722_095029_900823_BD03869E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-07-22 at 10:47 +0300, Maya Erez wrote:
> From: Ahmad Masri <amasri@codeaurora.org>
> 
> Send L2UF (Level 2 Update Frame) to update forwarding tables in layer 2
> in AP mode. Wil6210 driver creates and sends this frame once a new
> station connects to the AP.

Might be worth unifying with ieee80211_send_layer2_update() into a new
cfg80211 function?

johannes
