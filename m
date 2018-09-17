Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55858 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbeIQTT1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 15:19:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: sameo@linux.intel.com, davem@davemloft.net, netdev@vger.kernel.org
Cc: allen.pais@oracle.com, keescook@chromium.org, surenb@google.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/2] NFC fixes for 4.19-final
Date: Mon, 17 Sep 2018 15:51:39 +0200
Message-Id: <20180917135141.28328-1-gregkh@linuxfoundation.org> (sfid-20180917_155227_629915_CDB2751F)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some reason, these two NFC patches fell through the cracks.  It
looks like sometimes NFC patches go through the wireless tree, and
other times, through the networking tree directly.

I don't care which way they go, but they should get merged through some
way, or, I can take them in my device tree, but that feels a bit odd to
me.

thanks,

greg k-h

Suren Baghdasaryan (2):
  NFC: Fix possible memory corruption when handling SHDLC I-Frame
    commands
  NFC: Fix the number of pipes

 include/net/nfc/hci.h |  2 +-
 net/nfc/hci/core.c    | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.19.0
