Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:41432 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbeHTMsU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Aug 2018 08:48:20 -0400
Message-ID: <1534757602.6287.4.camel@sipsolutions.net> (sfid-20180820_113330_532040_D22952ED)
Subject: Re: [PATCH 0/3] Add support for ftm responder configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Mon, 20 Aug 2018 11:33:22 +0200
In-Reply-To: <cd1e8ef5693b81c6b5d25eae36a44fd3@codeaurora.org> (sfid-20180818_095014_905997_2F2749FC)
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
         <1534323867.3547.30.camel@sipsolutions.net>
         <4aaa3a6185dbd116ba5c1a2ce76b691f@codeaurora.org>
         <1534407150.3547.58.camel@sipsolutions.net>
         <cd1e8ef5693b81c6b5d25eae36a44fd3@codeaurora.org>
         (sfid-20180818_095014_905997_2F2749FC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-08-18 at 00:50 -0700, Pradeep Kumar Chitrapu wrote:
> > 
> I will change the attribute to FLAG type, also add support for LCI/CIVIC 
> params and repost the patch.

Looking at Android (for unrelated reasons), I see that they have a
separate "enable FTM responder" command:

https://android.googlesource.com/platform/hardware/interfaces/+/master/wifi/1.0/IWifiRttController.hal#158

Is that something you've seen/worked with? If so, how does it match your
current approach where FTM responder has to be enabled from the start?

Or perhaps this API is independent of AP and starts its own AP? But it
doesn't have any setup for the SSID etc., only the channel, so not clear
how that'd work?

johannes
