Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:35522 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdLaRl1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Dec 2017 12:41:27 -0500
Received: by mail-wr0-f170.google.com with SMTP id l19so32957986wrc.2
        for <linux-wireless@vger.kernel.org>; Sun, 31 Dec 2017 09:41:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171231172925.24014-1-erik.stromdahl@gmail.com>
References: <20171231172925.24014-1-erik.stromdahl@gmail.com>
From: Steve deRosier <derosier@gmail.com>
Date: Sun, 31 Dec 2017 09:41:26 -0800
Message-ID: <CALLGbRLrHfU6sURKOr=NQUrep9dRGhU5qsYLmCuwe0_CWnuy6w@mail.gmail.com> (sfid-20171231_184246_123462_6593947F)
Subject: Re: [RFC v4 00/18] ath10k high latency
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Erik,

On Sun, Dec 31, 2017 at 9:29 AM, Erik Stromdahl
<erik.stromdahl@gmail.com> wrote:
> Uplink test results (WUSB6100M -> other computer):
>
> # iperf-client.sh 192.168.1.244
> /usr/bin/iperf
> ------------------------------------------------------------
> Client connecting to 192.168.1.244, TCP port 1234
> TCP window size: 85.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.190 port 50524 connected with 192.168.1.244 port
> 1234
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.1 sec  10.8 MBytes  8.95 Mbits/sec
>
> The result is not so good (I expect more from an 11ac device),
> but hopefully it is configuration related.
>

Indeed. As a point of reference, an AR6004 device I have on my desk
(which is a/b/g/n, no ac), built into a custom SBC, I can normally get
iperf runs of >35 Mbits/sec.  So, in short, that run is showing
there's an issue. I don't have your device so I can't really help out
much more than that, but in the next week or so I'll try to look at
the patches and see if something pops to my eye.

- Steve
