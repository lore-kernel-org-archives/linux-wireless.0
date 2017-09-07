Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:36324 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752778AbdIGIkp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 04:40:45 -0400
Received: by mail-wr0-f180.google.com with SMTP id o42so7354550wrb.3
        for <linux-wireless@vger.kernel.org>; Thu, 07 Sep 2017 01:40:44 -0700 (PDT)
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: using vulnerability ids in patches
Message-ID: <7415a11b-398c-69df-b39f-7b985f07112b@broadcom.com> (sfid-20170907_104050_278210_DDE1DE8D)
Date: Thu, 7 Sep 2017 10:40:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Due to recent events we were asked about some vulnerability fixes for 
brcmfmac. We already fixed a couple of things without referring to a 
so-called CVE-ID, which is what people are asking for. Do we have a 
upstream policy on that? I could not really find anything in the 
Documentation folder (but I may have overlooked it). Might be worth 
mentioning in the commit message like with the coverity ids.

Regards,
Arend
