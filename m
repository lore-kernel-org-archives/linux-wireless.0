Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33167 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753069AbdFVJpb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 05:45:31 -0400
Received: by mail-lf0-f45.google.com with SMTP id m77so6897591lfe.0
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jun 2017 02:45:30 -0700 (PDT)
To: Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: net_device::destructor patch for brcmfmac
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <3f81fbd3-2896-2b09-1d59-ae5ec88045c9@broadcom.com> (sfid-20170622_114541_519084_7661E39E)
Date: Thu, 22 Jun 2017 11:45:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

I have a fix for brcmfmac, which is related to a change Dave made in
struct net_device, ie. commit cf124db566e6 ("net: Fix inconsistent
teardown and release of private netdev state."). This change is not in
wireless-drivers-next, but it is in mac80211-next and thus in
wireless-testing. What should I do? Submit to net-next, or
mac80211-next, or will you merge net-next into wireless-drivers-next?

Regards,
Arend
