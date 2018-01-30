Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59540 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbeA3Hy7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 02:54:59 -0500
Message-ID: <1517298897.2189.37.camel@sipsolutions.net> (sfid-20180130_085506_921889_F85E4E48)
Subject: Re: [PATCH 1/2] cfg80211: Add tx ack signal attribute in sta info
From: Johannes Berg <johannes@sipsolutions.net>
To: vnaralas@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>,
        linux-wireless-owner@vger.kernel.org
Date: Tue, 30 Jan 2018 08:54:57 +0100
In-Reply-To: <65e392b36ecf5b3161be954e974c4c0a@codeaurora.org>
References: <1516279208-16485-1-git-send-email-vnaralas@codeaurora.org>
         <1516623728.2508.4.camel@sipsolutions.net>
         <65e392b36ecf5b3161be954e974c4c0a@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-24 at 16:57 +0530, vnaralas@codeaurora.org wrote:
> 
> If user wants to get instant RSSI for the station which is ideal for 
> long time, user can sent null frame and get RSSI form the ack of that 
> null frame.

Then we really should make that part of the NL80211_CMD_PROBE_CLIENT
response, no?

johannes
