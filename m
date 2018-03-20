Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55898 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbeCTWzL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 18:55:11 -0400
Message-ID: <1521586508.19123.4.camel@sipsolutions.net> (sfid-20180320_235515_465678_002C2B87)
Subject: Re: [PATCH 10/10] rsi: drop RX broadcast/multicast packets with
 invalid PN
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Date: Tue, 20 Mar 2018 23:55:08 +0100
In-Reply-To: <1520260620-4694-11-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154940_119357_8A3160E9)
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
         <1520260620-4694-11-git-send-email-amitkarwar@gmail.com>
         (sfid-20180305_154940_119357_8A3160E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-03-05 at 20:07 +0530, Amitkumar Karwar wrote:
> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> 
> This patch adds a check to drop received broadcast/multicast frames
> if
> PN is invalid (i.e. not greater than last PN). bc_mc_pn
> variable added for each interface
> 
Can you say why you do this rather than letting mac80211 do it?

johannes
