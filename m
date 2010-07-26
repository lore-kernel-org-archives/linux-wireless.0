Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59681 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0GZUDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 16:03:08 -0400
Received: by pzk26 with SMTP id 26so1139393pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 13:03:06 -0700 (PDT)
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 26 Jul 2010 16:02:45 -0400
Message-ID: <AANLkTim4_HoHwdhGqAZqcGf2oq7boktdZFW4-w5DpdDa@mail.gmail.com>
Subject: *PING* iwlagn 2.6.35: "BA scd_flow 0 does not match txq_id 10"
	regression
To: linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's a regression in 2.6.35 where the connection breaks and iwlagn
writes a bunch of:

iwlagn 0000:03:00.0: BA scd_flow 0 does not match txq_id 10

This is confirmed [1] and a patch supposedly exists.  Since this
breaks at least two people's wireless and 2.6.35 is about to be
released, can we see the patches?

Thanks,
Andy

[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/53552
