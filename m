Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0088.outbound.protection.outlook.com ([104.47.37.88]:17394
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751669AbdH3COK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 22:14:10 -0400
Subject: Re: [PATCH 3/5] qtnfmac: modify qtnf_map_bar not to return NULL
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>
References: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
 <20170829121623.24761-4-sergey.matyukevich.os@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <424b7b13-0113-90ed-795c-b087d4610efa@quantenna.com> (sfid-20170830_041413_425346_89B5D7C4)
Date: Tue, 29 Aug 2017 19:14:02 -0700
MIME-Version: 1.0
In-Reply-To: <20170829121623.24761-4-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2017 05:16 AM, Sergey Matyukevich wrote:
> NULL is not a special type of success here but a error pointer.
> So it makes sense to check against NULL in qtnf_map_bar
> and return error code.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> ---

On a first glance not immediately obvious what is logically changed 
here, is it so that pr_debug() would not print NULL pointer?
