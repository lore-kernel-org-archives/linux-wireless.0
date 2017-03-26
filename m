Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:35526 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751477AbdCZUxt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Mar 2017 16:53:49 -0400
Received: by mail-pg0-f45.google.com with SMTP id 81so5574594pgh.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Mar 2017 13:53:48 -0700 (PDT)
Subject: Re: [PATCH v2] mac80211: Use rssi_threshold even though user_mpm=1
To: johannes@sipsolutions.net
References: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
 <1489730384-2799-1-git-send-email-masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <63b7e146-ae26-6f29-b864-57efeaf2f10c@gmail.com> (sfid-20170326_225417_563543_B2FDD71C)
Date: Mon, 27 Mar 2017 05:53:44 +0900
MIME-Version: 1.0
In-Reply-To: <1489730384-2799-1-git-send-email-masashi.honma@gmail.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017/03/17 14:59, Masashi Honma wrote:
> Previously the meshcfg.rssi_threshold did not work with user_mpm=1.
>
> Signed-off-by: Masashi Honma <masashi.honma@gmail.com>

Is there any comment ?

Masashi Honma.
