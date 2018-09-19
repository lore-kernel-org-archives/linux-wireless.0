Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39054 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbeITCYh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 22:24:37 -0400
Subject: Re: Netgear R7800 - ath10k QCA 9984 firmware crash
To: Bruno Rosset <bruno.rosset@gmail.com>,
        linux-wireless@vger.kernel.org
References: <CAKMn2kT6+4iX72jLSnCrXWMJ+pBHrMpZtigqWjzFRLKWRoxrkA@mail.gmail.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <1f79c9f7-86e5-b70a-9e0d-c021124a5d09@candelatech.com> (sfid-20180919_224502_345703_64590B8B)
Date: Wed, 19 Sep 2018 13:44:57 -0700
MIME-Version: 1.0
In-Reply-To: <CAKMn2kT6+4iX72jLSnCrXWMJ+pBHrMpZtigqWjzFRLKWRoxrkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2018 01:37 PM, Bruno Rosset wrote:
> Hi all,
>

> Various tests with others firmware from candelatech , stock LEDE 17.01
> or dd-wrt give me firmware crash also

Please open a bug for the candela firmware crash, I might be able to figure
out why it crashes:

https://github.com/greearb/ath10k-ct/issues

https://www.candelatech.com/ath10k-bugs.php

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
