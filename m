Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60740 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752702AbeC0NQO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 09:16:14 -0400
Message-ID: <1522156568.3050.19.camel@sipsolutions.net> (sfid-20180327_152422_879193_717E041C)
Subject: Re: [PATCH 1/3] ieee80211: Replace bit shifts with the BIT() macro
 for WLAN_CAPABILITY_*.
From: Johannes Berg <johannes@sipsolutions.net>
To: Quytelda Kahja <quytelda@tamalin.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 27 Mar 2018 15:16:08 +0200
In-Reply-To: <CAFLvi20sgO4aKTLYutvwUr5aN9TLaqLWVghC9Y9MrKZvcixAYA@mail.gmail.com>
References: <20180324041027.6498-1-quytelda@tamalin.org>
         <e31eb13b-598b-e7c7-607b-c98664818563@lwfinger.net>
         <CAFLvi20sgO4aKTLYutvwUr5aN9TLaqLWVghC9Y9MrKZvcixAYA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-03-24 at 16:02 -0700, Quytelda Kahja wrote:
> The "document" refers to the file in which the changes were made
> ('include/linux/ieee80211.h').

You're the first person ever to do that, to my knowledge :)

Either way, I don't really want to merge this since it would break
staging, and I don't want to merge a staging fix either... so you'd have
to get that sorted out first.

johannes
