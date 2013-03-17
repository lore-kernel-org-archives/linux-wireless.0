Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62192 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3CQUaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 16:30:46 -0400
Received: by mail-wi0-f182.google.com with SMTP id hi18so1935689wib.9
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2013 13:30:45 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC 0/2] mac80211: Enable VHT for non chanctxes drivers
Date: Sun, 17 Mar 2013 21:30:32 +0100
Message-Id: <1363552234-6752-1-git-send-email-karl.beldan@gmail.com> (sfid-20130317_213058_210864_88AECF47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

Here are 2 patches so that we can use vht with drivers that don't use 
channel contexes (which include non-hw scan,roc devices drivers).
These require modifications for said drivers, and I only have included 
mods for mac80211_hwsim. 

Johannes, could you please have a look and give me your feedback ? 
 
If this gets approved I will do a pass on every drivers and ask for testing
help (plus I only have an htc and an ar9170).

Thanks,
 
Karl

