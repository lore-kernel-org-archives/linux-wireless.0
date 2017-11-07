Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:54459 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933768AbdKGVPK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Nov 2017 16:15:10 -0500
Received: by mail-ua0-f175.google.com with SMTP id j14so438611uag.11
        for <linux-wireless@vger.kernel.org>; Tue, 07 Nov 2017 13:15:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a4c65d325abd4d4eb45d8cb3cd172df3@SC-EXCH02.marvell.com>
References: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
 <1509442967-14149-2-git-send-email-gbhat@marvell.com> <20171101212853.GA89416@google.com>
 <cb98c452aa344fc0b501a776cfa8708a@SC-EXCH02.marvell.com> <CAD=FV=VuxFtDdcMndLNzVYDoid8N3jP46j0sOFXG1D4CzX0=Zw@mail.gmail.com>
 <20171107022508.GA42502@google.com> <a4c65d325abd4d4eb45d8cb3cd172df3@SC-EXCH02.marvell.com>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 7 Nov 2017 13:15:08 -0800
Message-ID: <CAD=FV=ViNE5gnDTexYKpMN_Bb1bqZHwnJQ0h64=Rc8x-_1=iFQ@mail.gmail.com> (sfid-20171107_221514_231415_189EC4E4)
Subject: Re: [EXT] Re: [PATCH 1/3] mwifiex: cleanup rx_pkt_lock usage in 11n_rxreorder.c
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: Brian Norris <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Nov 7, 2017 at 8:25 AM, Ganapathi Bhat <gbhat@marvell.com> wrote:
> Hi Doug/Brian,
>
> Thanks a lot for the comments and the discussion. First of all we will abort the change added by this patch as we don't need rx_pkt_lock acquired to protect the deleted item.  Next, we will prepare below changes to address the concerns discussed:
> 1. Move rx_pkt_lock from mwifiex_private to rx_reorder_tbl

...or, possibly, remove rx_pkt_lock completely.  See my other response...

-Doug
