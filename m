Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:34285 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932769AbdC2UPM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 16:15:12 -0400
Received: by mail-ot0-f169.google.com with SMTP id a5so18181087oth.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Mar 2017 13:15:11 -0700 (PDT)
Subject: Re: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
To: Dennis New <dennisn@dennisn.mooo.com>,
        linux-wireless@vger.kernel.org
References: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
 <1490772890.18052.8.camel@sipsolutions.net>
 <20170329062808.032e71a5327f3405f82df4b2@dennisn.mooo.com>
 <1490788146.7948.19.camel@sipsolutions.net>
 <20170329153623.4a65bcf647c899f6bc5995ee@dennisn.mooo.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e2dc8492-1f48-07a4-da56-6b602da9ea2b@lwfinger.net> (sfid-20170329_221607_456150_8CEDD7D4)
Date: Wed, 29 Mar 2017 15:15:09 -0500
MIME-Version: 1.0
In-Reply-To: <20170329153623.4a65bcf647c899f6bc5995ee@dennisn.mooo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2017 02:36 PM, Dennis New wrote:
> global
> country 00: DFS-UNSET
>         (2402 - 2472 @ 92), (N/A, 20), (N/A)
>         (2457 - 2482 @ 92), (N/A, 20), (N/A), PASSIVE-SCAN
>         (2474 - 2494 @ 20), (N/A, 20), (N/A), NO-OFDM, PASSIVE-SCAN
>         (5170 - 5250 @ 160), (N/A, 20), (N/A), PASSIVE-SCAN
>         (5250 - 5330 @ 160), (N/A, 20), (0 ms), DFS, PASSIVE-SCAN
>         (5490 - 5730 @ 160), (N/A, 20), (0 ms), DFS, PASSIVE-SCAN
>         (5735 - 5835 @ 80), (N/A, 20), (N/A), PASSIVE-SCAN
>         (57240 - 63720 @ 2160), (N/A, 0), (N/A)

That "country 00" looks like commit 1d2a6a5e4bf2921531071fcff8538623dce74efa
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Wed Mar 22 16:08:33 2017 +0100

     genetlink: fix counting regression on ctrl_dumpfamily()

Larry
