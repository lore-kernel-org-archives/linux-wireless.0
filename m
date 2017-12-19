Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42212 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdLSRAq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 12:00:46 -0500
Message-ID: <1513702844.26145.19.camel@sipsolutions.net> (sfid-20171219_180239_908318_D1F65A49)
Subject: Re: [RFC PATCH 2/2] nl80211: implement beacon change notifier
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Marianna Carrera <mcarrera@quantenna.com>
Date: Tue, 19 Dec 2017 18:00:44 +0100
In-Reply-To: <20171205203129.flqhqrwa5y7uhgoz@bars>
References: <20171109094024.9085-1-sergey.matyukevich.os@quantenna.com>
         <20171109094024.9085-2-sergey.matyukevich.os@quantenna.com>
         <1510565429.30497.10.camel@sipsolutions.net>
         <20171113115841.3dcrcjqnp543kndi@bars>
         <1510575765.30497.38.camel@sipsolutions.net>
         <20171115153547.kkunkrfcivoqcsq2@bars>
         <1511784144.5456.12.camel@sipsolutions.net>
         <20171205203129.flqhqrwa5y7uhgoz@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sergey,

Sorry for the long delay.

On Tue, 2017-12-05 at 23:31 +0300, Sergey Matyukevich wrote:
> 
> By the way, speaking about GET_CMD_BEACON and its possible users in the
> community. There is already a stub for it in nl80211 uapi headers. What
> was the original idea for that ? Or was it just a placeholder added
> together with SET_BEACON ?

I think it was a placeholder, you can probably find it in git history.
I vaguely remember thinking - many years ago - that all the operations
should consistently support add, del, set and get, but that isn't
really all that practical.

johannes
