Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:39856 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932681AbeCEIoA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 03:44:00 -0500
Received: by mail-qt0-f169.google.com with SMTP id n9so4558723qtk.6
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 00:44:00 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: debugfs entries in cfg80211
Message-ID: <5A9D034D.9060203@broadcom.com> (sfid-20180305_094404_623494_FD5A0F98)
Date: Mon, 5 Mar 2018 09:43:57 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

While reworking brcmfmac I stumbled on debugfs code in cfg80211, which 
creates the debugfs dir for the wiphy instance. It also creates a couple 
of entries, ie. rts and fragmentation threshold and retry limits. How 
useful are these as I suspect it is pretty old cruft and iw can obtain 
the information as well. Can it be removed.

Regards,
Arend
