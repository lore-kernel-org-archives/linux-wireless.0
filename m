Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65254 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1DGK1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 06:27:05 -0400
Received: by vws1 with SMTP id 1so1783912vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 03:27:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Apr 2011 12:27:04 +0200
Message-ID: <BANLkTin+2wSi1Hgok1UATZ9xeEgtkjzuzA@mail.gmail.com>
Subject: Obtain peer statistic from net_device struct
From: Daniele Furlan <daniele.furlan@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I'm modifing B.A.T.M.A.N. mesh network routing protocol in order to
take into account the tx bitrate.
I know the net_device struct of each physical device, how can I check
if the device supports mac80211 and obtain a pointer to the struct
containg the statistics or something similar (maybe ieee80211_local or
wiphy)?
I have checked iw code without success.

Thanks in advance.

-- 
Daniele Furlan
