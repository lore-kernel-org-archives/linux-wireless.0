Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:57314 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbeHUM0b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 08:26:31 -0400
Message-ID: <1534842427.25523.2.camel@sipsolutions.net> (sfid-20180821_110713_868832_F5CA645C)
Subject: Re: [PATCH] cfg80211: remove division by size of sizeof(struct
 ieee80211_wmm_rule)
From: Johannes Berg <johannes@sipsolutions.net>
To: Grzegorz =?UTF-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Aug 2018 11:07:07 +0200
In-Reply-To: <fbaa39a3-7937-7ecf-040a-c86433baadc7@gmail.com> (sfid-20180821_110632_802318_612B35B7)
References: <20180820073705.9683-1-johannes@sipsolutions.net>
         <20180820102710.GA2760@redhat.com>
         <63f44789-11c3-0549-b8b8-cd3b25c40547@gmail.com>
         <1534842181.25523.1.camel@sipsolutions.net>
         <fbaa39a3-7937-7ecf-040a-c86433baadc7@gmail.com>
         (sfid-20180821_110632_802318_612B35B7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I can try to recreate the issue with hwsim, it will take me some time 
> probably as I have no prior experience.

No worries, I'm compiling it now. Do you have a special hostapd
configuration?

johannes
