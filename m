Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:35240 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752719AbdGLO5p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2017 10:57:45 -0400
Received: by mail-lf0-f46.google.com with SMTP id b207so19400375lfg.2
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jul 2017 07:57:45 -0700 (PDT)
Subject: Re: [PATCH for-4.13] brcmfmac: fix regression in
 brcmf_sdio_txpkt_hdalign()
To: Bob Copeland <me@bobcopeland.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
References: <1499851968-18768-1-git-send-email-arend.vanspriel@broadcom.com>
 <20170712142901.evso24vh3jfj6umk@localhost>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <819501de-724e-889f-1b45-b3e4addd0d1a@broadcom.com> (sfid-20170712_165750_115887_A59A43A9)
Date: Wed, 12 Jul 2017 16:57:42 +0200
MIME-Version: 1.0
In-Reply-To: <20170712142901.evso24vh3jfj6umk@localhost>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-07-17 16:29, Bob Copeland wrote:
> On Wed, Jul 12, 2017 at 10:32:48AM +0100, Arend van Spriel wrote:
>> Recent change in brcmf_sdio_txpkt_hdalign() changed the
>> behavior and now always returns 0. This resulted in a
>> regression which basically renders the device useless.
> 
> Should this go via netdev as well, or just wait for Kalle (returning
> on Sunday)?

Hi Bob,

This regression got introduced recently so the issue will pop-up in
v4.13-rc1 hence I figured we can wait for Kalle with this one.

Regards,
Arend
