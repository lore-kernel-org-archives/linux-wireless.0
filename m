Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:60184 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0DLMZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 08:25:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1O1IhL-0002iK-TD
	for linux-wireless@vger.kernel.org; Mon, 12 Apr 2010 14:25:04 +0200
Received: from 203.200.35.32.ill-bgl.static.vsnl.net.in ([203.200.35.32.ill-bgl.static.vsnl.net.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 14:25:03 +0200
Received: from snehaatpec by 203.200.35.32.ill-bgl.static.vsnl.net.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 14:25:03 +0200
To: linux-wireless@vger.kernel.org
From: Sneha Aggarwal <snehaatpec@gmail.com>
Subject: Frame aggregation size configuration in 802.11n
Date: Mon, 12 Apr 2010 12:11:22 +0000 (UTC)
Message-ID: <loom.20100412T140919-620@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all

I think this is the appropriate place to post this query.
I am studying the effect of frame aggregation size on throughput for my project.
Is there any direct command to change the aggregation size like iwconfig/iwpriv
or something?

I have gone through the kernel code of aggregation from the file agg-tx.c from
the linux-2.6.32.7 
and the exact path is linux-2.6.32.7/net/mac80211/agg-tx.c
The function which I have recognized to change the aggregation size is:
ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata, const u8 *da,
u16 tid, u8 dialog_token, u16 start_seq_num, u16 agg_size, u16 timeout)

I am wondering if this is the right place to change the parameter or not. Or is
there any other way to change this parameter without changing the kernel file
directly? 
and where all I have to change this parameter to get the desired output?
And I am planning to write of a piece of code to make this parameter available
to the user to configure.

-- 
Regards
Sneha Aggarwal

