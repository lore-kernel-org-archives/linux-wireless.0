Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li834-156.members.linode.com ([104.237.146.156]:48061 "EHLO
        offmail.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbdARA4P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 19:56:15 -0500
Date: Wed, 18 Jan 2017 00:40:02 -0500
From: Farhan Khan <farhan@offmail.us>
To: linux-wireless@vger.kernel.org
Subject: Clarifying rtl8188ee's channel wifi changing code
Message-ID: <20170118054001.GA88602@offmail.us> (sfid-20170118_015628_468548_7E37638C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am having a bit of trouble understanding the rtl8188ee source,
specifically how its switch_channel function (rtl88e_phy_sw_chnl) works. I
gather that this function calls rtl88ee_phy_sw_chnl_callback, which in turn
calls _rtl88_phy_sw_chnl_step_by_step (
https://github.com/torvalds/linux/blob/master/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c#L1253
).

This is where I get lost. Where is the 'channel' variable used, other than
to change the TX power? I presume it has something to do with case
CMDID_RF_WRITEREG, but I am not certain.

Please explain what is going on. Thank you!
