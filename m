Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:34279 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754493AbcJVTNK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 15:13:10 -0400
Received: by mail-qt0-f175.google.com with SMTP id q7so107820390qtq.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2016 12:13:10 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: cookie_counter in wiphy object
Message-ID: <0e3d457d-b0d1-f2b1-b18b-3f7b3e95365c@broadcom.com> (sfid-20161022_211315_072299_73335A3F)
Date: Sat, 22 Oct 2016 21:13:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Since commit a442b761b24b ("cfg80211: add add_nan_func / del_nan_func")
there is a cookie_counter in the wiphy object. It is only used by the
add_nan_func now, but do we want to consolidate all cookie returning
functions to use this cookie counter, eg. in .remain_on_channel callback.

Regards,
Arend
