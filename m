Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:35720 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbcBDL17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 06:27:59 -0500
Received: by mail-yw0-f177.google.com with SMTP id g127so24695907ywf.2
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 03:27:59 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 4 Feb 2016 16:52:25 +0530
Message-ID: <CABPxzY+HpP=NTrAaUEzV5nFm=LK93m=kxPV14-cdftt+VPsWNw@mail.gmail.com> (sfid-20160204_122805_666177_9914C15E)
Subject: mac80211_hwsim + iperf + netns
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I am trying to run some iperf tests using mac80211_hwsim b/w AP and STA.
Even after tweaking the routing table, the packets are still not going through
mac80211_hwsim instead they are just looping back.

After a quick search i found that we should use different network namespaces.
Can anyone tell me the exact procedure for this? I have found a procedure
in the below link, but i dont have the lxc-unshare for my embedded box.
Is there any alternate way for this.

https://github.com/bcopeland/wmediumd


-- 
Thanks,
Regards,
Chaitanya T K.
