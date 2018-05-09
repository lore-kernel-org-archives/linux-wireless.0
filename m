Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53516 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964968AbeEIV3l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 17:29:41 -0400
Message-ID: <1525901377.6910.29.camel@sipsolutions.net> (sfid-20180509_232947_329731_77DF5748)
Subject: Re: pull-request: mac80211-next 2018-05-09
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Wed, 09 May 2018 23:29:37 +0200
In-Reply-To: <20180509194034.11992-1-johannes@sipsolutions.net> (sfid-20180509_214049_113840_06178292)
References: <20180509194034.11992-1-johannes@sipsolutions.net>
         (sfid-20180509_214049_113840_06178292)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry, scratch that.

I forgot that this commit:

> Toke Høiland-Jørgensen (3):

>       cfg80211: Expose TXQ stats and parameters to userspace

caused a bunch of "too much stack" warnings - I should put in at least
the non-driver fix for that first, and then coordinate with Kalle to
send the driver fixes in too.

johannes
