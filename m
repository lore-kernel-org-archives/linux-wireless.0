Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:56696 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752470AbdLKOMq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 09:12:46 -0500
Message-ID: <1513001564.26976.81.camel@sipsolutions.net> (sfid-20171211_151250_724902_D93F1616)
Subject: Re: 76f43b4 fix for stable
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard =?ISO-8859-1?Q?Sch=FCtz?= <rschuetz@uni-koblenz.de>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Stable <stable@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>
Date: Mon, 11 Dec 2017 15:12:44 +0100
In-Reply-To: <c0a512a7-e615-bbab-5c88-4a85946fefb5@uni-koblenz.de> (sfid-20171211_145144_843553_B9CBDEA2)
References: <c0a512a7-e615-bbab-5c88-4a85946fefb5@uni-koblenz.de>
         (sfid-20171211_145144_843553_B9CBDEA2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-12-11 at 14:51 +0100, Richard Schütz wrote:
> Hello,
> 
> as per netdev-FAQ.txt I'm requesting the submission of commit 
> 57629915d568c522ac1422df7bba4bee5b5c7a7c ("mac80211: Fix addition of 
> mesh configuration element") to stable. Because of automatic selection 
> commit 76f43b4c0a9337af22827d78de4f2b8fd5328489 ("mac80211: Remove 
> invalid flag operations in mesh TSF synchronization") was introduced 
> into stable recently without this accompanying fix.

It seems that due to the Fixes: tag Greg should pick it up anyway, but
in any case I don't really deal with stable myself (in that sense, I
guess wireless isn't really part of netdev...)

johannes
