Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36651 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753217AbeBSRr7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 12:47:59 -0500
Received: by mail-wm0-f47.google.com with SMTP id f3so16616802wmc.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Feb 2018 09:47:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPWex-AFApTucOo4DGk2n30X7Y0N2NrNv2u+8ubqTL4SkhxgwA@mail.gmail.com>
References: <CAPWex-AFApTucOo4DGk2n30X7Y0N2NrNv2u+8ubqTL4SkhxgwA@mail.gmail.com>
From: Steve deRosier <derosier@gmail.com>
Date: Mon, 19 Feb 2018 09:47:57 -0800
Message-ID: <CALLGbR+taP7GU4ftX5wFPvxD0BUsCiBDxjGXWeOJi9_nYLhEww@mail.gmail.com> (sfid-20180219_184803_193361_88272DAB)
Subject: Re: testing tool for packet delay
To: sdnlabs Janakaraj <wsuprabhu@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 19, 2018 at 9:19 AM, sdnlabs Janakaraj <wsuprabhu@gmail.com> wrote:
>
> Hello All,
>
> I am working on delay analysis of packets in wireless stacks. I am
> able to see lots of papers talk about therotical analysis. But I am
> more interested in practical evaluation.
>
> I am reaching out to developers community to learn how they actually
> evaluate the performance of the stack. In particular, I am looking for
> ideas to evaluate the delay experienced by packets within the
> mac802.11 stack.
>

Hi Prabhu,

Sounds like an interesting project. More often my instrumentation
focuses on aggregate performance and iperf throughput numbers suffices
for most of that. Occasionally I utilize internal performance measures
and/or data provided me by ftrace and related tools.

If you're unfamiliar with it, I suggest you look at the Bufferbloat
and Make-wifi-fast projects. I suspect that their data and techniques
and tools might be of interest to you:

https://www.bufferbloat.net/projects/make-wifi-fast/

Also (shameless plug), I'll be discussing WiFi integration debugging
techniques and tools at the ELC-NA conference in March. Some of it
might be relevant. If you're going, please stop by and say hi.

http://sched.co/DXn3

I hope that helps.

- Steve

--
Steve deRosier
Cal-Sierra Consulting LLC
https://www.cal-sierra.com/
