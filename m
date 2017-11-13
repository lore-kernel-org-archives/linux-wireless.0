Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:47752 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751262AbdKMJab (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 04:30:31 -0500
Message-ID: <1510565429.30497.10.camel@sipsolutions.net> (sfid-20171113_103121_104076_A691A382)
Subject: Re: [RFC PATCH 2/2] nl80211: implement beacon change notifier
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Date: Mon, 13 Nov 2017 10:30:29 +0100
In-Reply-To: <20171109094024.9085-2-sergey.matyukevich.os@quantenna.com>
References: <20171109094024.9085-1-sergey.matyukevich.os@quantenna.com>
         <20171109094024.9085-2-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-11-09 at 12:40 +0300, Sergey Matyukevich wrote:
> From: Vasily Ulyanov <vulyanov@quantenna.com>
> 
> Notify user-space listeners about beacon data change.

What would this be needed for, and why couldn't you just directly talk
to hostapd/wpa_s?

johannes
