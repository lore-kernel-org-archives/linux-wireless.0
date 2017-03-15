Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:32820 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754132AbdCOVx5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 17:53:57 -0400
Received: by mail-lf0-f43.google.com with SMTP id a6so12727883lfa.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Mar 2017 14:53:56 -0700 (PDT)
MIME-Version: 1.0
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Date: Wed, 15 Mar 2017 14:53:54 -0700
Message-ID: <CAAA5faEQwWgkifyk_=aSr303yBQ-jGL=PZPQJz4u9+M20EDgKw@mail.gmail.com> (sfid-20170315_225438_230319_E908B881)
Subject: accessing function send_addba_request
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Everyone,

In kernel space I can easily call the function ieee_send_addba_request.
Is there are way to call this function from userland by cfg80211 or nl80211?
Thanks,

Reinoud.
