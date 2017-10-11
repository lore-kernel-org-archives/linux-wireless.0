Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48846 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752417AbdJKTwk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 15:52:40 -0400
Subject: Re: [PATCH] [net-next]NFC: Convert timers to use timer_setup()
To: davem@davemloft.net
References: <1507718024-2134-1-git-send-email-allen.pais@oracle.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        keescook@chromium.org
From: Allen <allen.pais@oracle.com>
Message-ID: <59DE767F.2020304@oracle.com> (sfid-20171011_215309_030695_231CA20F)
Date: Thu, 12 Oct 2017 01:22:31 +0530
MIME-Version: 1.0
In-Reply-To: <1507718024-2134-1-git-send-email-allen.pais@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Switch to using the new timer_setup() and from_timer()
> for net/nfc/*
>
> Signed-off-by: Allen Pais <allen.pais@oracle.com>
> ---
> ---
>   net/nfc/core.c          |  8 +++-----
>   net/nfc/hci/core.c      |  7 +++----
>   net/nfc/hci/llc_shdlc.c | 23 +++++++++--------------
>   net/nfc/llcp_core.c     | 14 ++++++--------
>   4 files changed, 21 insertions(+), 31 deletions(-)
>

  My bad, I missed the Reviewed-by.

Reviewed-by: Kees Cook <keescook@chromium.org>

- Allen
