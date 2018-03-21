Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60858 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbeCUICq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 04:02:46 -0400
Message-ID: <1521619364.2645.12.camel@sipsolutions.net> (sfid-20180321_090252_215994_8B37E4CE)
Subject: Re: [PATCH] mac80211: notify driver for change in multicast rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 21 Mar 2018 09:02:44 +0100
In-Reply-To: <1521589929-13997-1-git-send-email-pradeepc@codeaurora.org>
References: <1521589929-13997-1-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-03-20 at 16:52 -0700, Pradeep Kumar Chitrapu wrote:
> It is required to pass the rate information to driver/firmware
> when rate control is offloaded to firmware. This helps in changing
> multicast traffic rates thereby improving the network performance.

Looks like there are two more places where you should set the new flag?

johannes
