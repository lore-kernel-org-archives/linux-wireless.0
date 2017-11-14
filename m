Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:56638 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdKNAB1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 19:01:27 -0500
Received: by mail-wm0-f41.google.com with SMTP id z3so18615384wme.5
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2017 16:01:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL3ir7JHwLpNFRSv0jEED50XeFAWmSz4gXXOs0MpM=VeTGiKnQ@mail.gmail.com>
References: <CAL3ir7JHwLpNFRSv0jEED50XeFAWmSz4gXXOs0MpM=VeTGiKnQ@mail.gmail.com>
From: Steve deRosier <derosier@gmail.com>
Date: Mon, 13 Nov 2017 16:01:25 -0800
Message-ID: <CALLGbRKwcm0ugSKAV1p3rxGseAkp6Zk9RZvKZeTrWFJ_=-pSKg@mail.gmail.com> (sfid-20171114_010143_415814_F55F618E)
Subject: Re: PS-Poll not behaving as expected
To: Daniel Ghansah <smartwires@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On Mon, Nov 13, 2017 at 2:40 PM, Daniel Ghansah <smartwires@gmail.com> wrote:
>        Here is the problem we experience:
>
> When the station (wifi devices) sends a null QoS frame with power save
> telling our AP that it is going into power save mode. RIght now, our
> problem is that the AP will not stop sending data packets to the
> station. Correct behavior is that the AP will buffer data packets and
> stop sending any data or null packets (WiFi Alliance allows at most 2
> of these packets to be sent by the AP before station sends ps-poll,
> exclude retries) until a PS-Poll packet is sent by the station to
> collect data. The AP should also respond only 1 packet per PS-Poll
> (exclude any retries). Right now, we are also experiencing that the AP
> will, at times, send more than 1 data packet to the station per
> PS-Poll. The first and second problems may be linked together.
>

You've given no context with which we can help you. Things like the
Linux version, the hardware running on the AP and client, which it is
you're trying to report a bug on (the AP or Client), dmesg logs,
wireless traces, and so on would all be somewhere between mandatory to
helpful information. Trying to give us nothing but your interpretation
of what the 802.11 standard says (which most of us know very well)
isn't a useful bug report.

This might help:
https://wireless.wiki.kernel.org/en/users/documentation/reporting_bugs

Please try again and send us the information we need to be able to help.

Thanks,
- Steve
