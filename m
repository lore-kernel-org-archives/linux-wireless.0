Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:56887 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752225AbdJKOMw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 10:12:52 -0400
MIME-Version: 1.0
In-Reply-To: <1507708082.1998.9.camel@sipsolutions.net>
References: <20171011023149.18021-1-qasdfgtyuiop@gmail.com> <1507708082.1998.9.camel@sipsolutions.net>
From: Xiang Gao <qasdfgtyuiop@gmail.com>
Date: Wed, 11 Oct 2017 10:12:30 -0400
Message-ID: <CAMtaSwRNc0JvyG04SpW2DxNyzdCtwE0o0i2biMF6Wm+53NHmDg@mail.gmail.com> (sfid-20171011_161408_416787_BDD723D5)
Subject: Re: [PATCH v3] mac80211: aead api to reduce redundancy
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great ! Thanks !
Xiang Gao


2017-10-11 3:48 GMT-04:00 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2017-10-10 at 22:31 -0400, Xiang Gao wrote:
>> Currently, the aes_ccm.c and aes_gcm.c are almost line by line copy
>> of
>> each other. This patch reduce code redundancy by moving the code in
>> these
>> two files to crypto/aead_api.c to make it a higher level aead api.
>> The
>> file aes_ccm.c and aes_gcm.c are removed and all the functions there
>> are
>> now implemented in their headers using the newly added aead api.
>
> Applied. FWIW, the sta_dynamic_down_up test that the robot complained
> about, and the PSK tests that heavily use CCMP all pass.
>
> johannes
