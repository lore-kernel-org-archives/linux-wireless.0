Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37536 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752743AbdECKEu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 06:04:50 -0400
Received: by mail-wm0-f50.google.com with SMTP id m123so51311988wma.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 03:04:50 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: when to use wdev_lock()
Message-ID: <49584b67-0bdf-0acf-fb98-a7bea5978fbc@broadcom.com> (sfid-20170503_120454_870930_D2EBC70E)
Date: Wed, 3 May 2017 12:04:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I bumped into use of wdev_lock() again with 802.1X 4-way-hs offload 
stuff. So for .set_pmk() and .del_pmk() it takes wdev_lock(). Is there a 
rule of thumb when this lock is needed. What is it protecting in general 
and in the case of pmk configuration.

Regards,
Arend
