Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36448 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753725AbeAOMIn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 07:08:43 -0500
Message-ID: <1516018121.410.13.camel@sipsolutions.net> (sfid-20180115_130847_256091_B04E59EF)
Subject: Re: [PATCH v3 3/5] mac80211_hwsim: add generation count for netlink
 dump operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 15 Jan 2018 13:08:41 +0100
In-Reply-To: <44644db1-58a4-4b6e-a77e-37c72ee2e4a6@MAIL2.uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
         <44644db1-58a4-4b6e-a77e-37c72ee2e4a6@MAIL2.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-10 at 17:42 +0100, Benjamin Beichler wrote:
>  Change the dump iteration to be independent from
> increasing radio indices on radio list.

You can't do that, data structures can be deleted while the dump is
ongoing.

johannes
