Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37533 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752506AbdFVAEC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 20:04:02 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 4C68C207F7
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2017 20:03:51 -0400 (EDT)
Received: from localhost (202-159-179-103.dyn.iinet.net.au [202.159.179.103])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9C8F07E271
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2017 20:03:50 -0400 (EDT)
Date: Thu, 22 Jun 2017 10:03:47 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: linux-wireless@vger.kernel.org
Subject: cfg80211_ops
Message-ID: <20170622000347.GA15458@eros> (sfid-20170622_020412_371423_1EC13E2B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Is some one able to please confirm for me that the following
cfg80211_ops callbacks are enough to implement a minimal functioning
Wi-Fi driver. Assume that a virtual interface is added during driver
initialization.

scan
add_key
get_key
del_key
sat_default_key
connect
disconnect
set_wiphy_params

thanks,
Tobin
