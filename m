Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40976 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753165AbdC2GZg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 02:25:36 -0400
Message-ID: <1490768721.18052.4.camel@sipsolutions.net> (sfid-20170329_082546_762214_F913FA8A)
Subject: Re: Formatting of db.txt
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthew Stanger <matthew_stanger@trimble.com>,
        Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 29 Mar 2017 08:25:21 +0200
In-Reply-To: <CANr77M2fspR0fk-kDrfaF6ONcZmdzyVk3G5f6NywZ5-PRkFCwA@mail.gmail.com> (sfid-20170329_054926_640389_BDFEC74B)
References: <CANr77M0xc=zD17HK1Gu2GT7Y_P=QC65UrHkvwj+JntenHSHNSA@mail.gmail.com>
         <CABPxzYKF4+M_cooukAA5oKJu0quB4CjOHaRr1qQjHMRYAPhE4A@mail.gmail.com>
         <CANr77M2fspR0fk-kDrfaF6ONcZmdzyVk3G5f6NywZ5-PRkFCwA@mail.gmail.com>
         (sfid-20170329_054926_640389_BDFEC74B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-03-28 at 21:49 -0600, Matthew Stanger wrote:
> I also notice when I run 'iw reg get' it still shows the format which
> seems to support the antenna gain (N/A):
> country US: DFS-FCC
>         (2402 - 2472 @ 40), (N/A, 25), (N/A)
>         (5170 - 5250 @ 80), (N/A, 16), (N/A)
>         (5250 - 5330 @ 80), (N/A, 16), (N/A)
>         (5490 - 5730 @ 160), (N/A, 16), (N/A)
>         (5735 - 5835 @ 80), (N/A, 23), (N/A)
> 
> If this isn't supported by the .db anymore then maybe this format
> should be updated in configuration utility.

Not really - this tool should still support older kernels.

johannes
