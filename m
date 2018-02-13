Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:40146 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934165AbeBMKnq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 05:43:46 -0500
Received: by mail-qt0-f196.google.com with SMTP id c19so3099262qtm.7
        for <linux-wireless@vger.kernel.org>; Tue, 13 Feb 2018 02:43:46 -0800 (PST)
Subject: Re: [PATCHv2 1/3] cfg80211: send ack_signal to user in probe client
 response
To: Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        johannes@sipsolutions.net
References: <1518499986-10606-1-git-send-email-vnaralas@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A82C15F.7060906@broadcom.com> (sfid-20180213_114351_915613_52B70AFF)
Date: Tue, 13 Feb 2018 11:43:43 +0100
MIME-Version: 1.0
In-Reply-To: <1518499986-10606-1-git-send-email-vnaralas@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/13/2018 6:33 AM, Venkateswara Naralasetty wrote:
> This patch provides support to get ack signal in probe client response
> and in station info from user.

Hi Venkateswara,

In recent discussion [1] it was observed that a valid flag would not 
really be needed as a signal level of zero could be used as valid 
indication.

Regards,
Arend

[1] https://www.spinics.net/lists/linux-wireless/msg170023.html

> Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> ---
> v2:
> * addressed Johannes comments
>
>   include/net/cfg80211.h       | 7 ++++++-
>   include/uapi/linux/nl80211.h | 3 +++
>   net/wireless/nl80211.c       | 8 ++++++--
>   3 files changed, 15 insertions(+), 3 deletions(-)
