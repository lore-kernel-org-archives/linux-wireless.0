Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37514 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731681AbeHNOMJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 10:12:09 -0400
Message-ID: <1534245864.3547.22.camel@sipsolutions.net> (sfid-20180814_132529_235870_14D9AA5E)
Subject: Re: [PATCH] cfg80211/mac80211: make ieee80211_send_layer2_update a
 public function
From: Johannes Berg <johannes@sipsolutions.net>
To: Dedy Lansky <dlansky@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Date: Tue, 14 Aug 2018 13:24:24 +0200
In-Reply-To: <1532865556-25398-1-git-send-email-dlansky@codeaurora.org>
References: <1532865556-25398-1-git-send-email-dlansky@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-07-29 at 14:59 +0300, Dedy Lansky wrote:
> Make ieee80211_send_layer2_update() a common function so other drivers
> can re-use it.
> Add support in wil6210 to send L2UF on behalf of newly associated
> station by calling the common function.
> 
> Change-Id: Ic2daa1b8392122931103eb5a963e14f8270818bb
> 

Applied, but without the wil6210 support - please make a separate patch
for that. I also stripped the Change-Id :)

johannes
