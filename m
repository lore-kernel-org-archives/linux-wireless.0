Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:50989 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754614AbeFTI6V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 04:58:21 -0400
Received: by mail-wm0-f65.google.com with SMTP id e16-v6so4693250wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2018 01:58:20 -0700 (PDT)
Subject: Re: [PATCH] mac80211: Fix oops in ieee80211_tx_control_port
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net
References: <20180619153950.28903-1-denkenz@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B2A0772.4060200@broadcom.com> (sfid-20180620_105902_442195_34CAAD79)
Date: Wed, 20 Jun 2018 09:51:14 +0200
MIME-Version: 1.0
In-Reply-To: <20180619153950.28903-1-denkenz@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/19/2018 5:39 PM, Denis Kenzior wrote:
> On pre-emption enabled kernels the following oops was being seen due
> to missing local_bh_disable/local_bh_enable calls.  mac80211 assumes
> that pre-emption is disabled in the data path.

No sure if "assumes" is the right term here. It seems like it is
required and there is probably a good reason for that. Would be nice to
know what that reason is.

Regards,
Arend
