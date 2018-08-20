Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:40444 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbeHTLX0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Aug 2018 07:23:26 -0400
Message-ID: <1534750654.6287.0.camel@sipsolutions.net> (sfid-20180820_100851_742745_C513403B)
Subject: Re: Cpu stall caused by hostapd running two interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Grzegorz =?UTF-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Date: Mon, 20 Aug 2018 09:37:34 +0200
In-Reply-To: <20180813084123.GA18180@redhat.com>
References: <CAD7cUuBrMscCMzLHCdxaAf+m9XHLr6XWD+FmZqNSdAuYnKCZfw@mail.gmail.com>
         <20180813084123.GA18180@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This is oops in ieee80211_regulatory_limit_wmm_params().
> Looks like new regulatory code do not like ath10k.
> I have another bug report with reg.c WARNING also on ath10k:
> https://bugzilla.redhat.com/show_bug.cgi?id=1612537
> 
> 
Sorry for the delay. I just sent out a patch that I thought we had
already, but clearly don't - can you see if that helps?

johannes
