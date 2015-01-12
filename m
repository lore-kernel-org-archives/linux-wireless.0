Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:39614 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbbALJfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 04:35:15 -0500
Received: by mail-qa0-f49.google.com with SMTP id v8so4456835qal.8
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 01:35:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
References: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
Date: Mon, 12 Jan 2015 09:35:13 +0000
Message-ID: <CAFSJ42Z2VagmLsq_+BB217CDU1-_GVcSGQ=0UWBFzvcbMq7cug@mail.gmail.com> (sfid-20150112_103519_645568_0D0C84D7)
Subject: Re: [PATCH 0/8] wcn36xx locking and a-mpdu fixes
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks good to me!

2015-01-09 19:15 GMT+00:00 Bob Copeland <me@bobcopeland.com>:
> Hello,
>
> These patches have been merged into the wcn36xx github tree but have
> been collecting dust for some time.  I pinged Eugene (CCed) who said I
> could just go ahead and send them upstream.  Rebased and re-tested on
> an Android target (and newer checkpatch warnings removed).
>
> At some point I can go through other patches (not by me) that aren't yet
> upstream and send them along as well, unless someone else wants to do that.
>
> Bob Copeland (8):
>   wcn36xx: initialize device defaults on start
>   wcn36xx: use !! when assigning int as a boolean
>   wcn36xx: let device generate qos seq numbers
>   wcn36xx: don't process 'valid' descriptors
>   wcn36xx: initialize skb_lock
>   wcn36xx: initialize dxe lock
>   wcn36xx: move set_tx_pdu inside set_tx_data/mgmt
>   wcn36xx: initiate TX BA sessions
>
>  drivers/net/wireless/ath/wcn36xx/dxe.c     |    3 +
>  drivers/net/wireless/ath/wcn36xx/main.c    |   16 +++++-
>  drivers/net/wireless/ath/wcn36xx/smd.c     |   73 +++++++++++++++++++++++-
>  drivers/net/wireless/ath/wcn36xx/txrx.c    |   83 ++++++++++++++++++++++------
>  drivers/net/wireless/ath/wcn36xx/txrx.h    |    9 ++-
>  drivers/net/wireless/ath/wcn36xx/wcn36xx.h |   20 +++++++
>  6 files changed, 182 insertions(+), 22 deletions(-)
>
> --
> 1.7.10.4
>



-- 
Best regards,
Eugene
