Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f193.google.com ([209.85.212.193]:36629 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856Ab3DZKkl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 06:40:41 -0400
Received: by mail-wi0-f193.google.com with SMTP id m6so181481wiv.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2013 03:40:39 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 26 Apr 2013 16:10:39 +0530
Message-ID: <CAHiw28wHoD+gd2R41J3L97DxLZk3jdMPRfrivu0s8+FBgLCsvw@mail.gmail.com> (sfid-20130426_124053_990889_82BEB618)
Subject: Missing WMI_BSSINFO_EVENTID from AR6004
From: Manohar Narkhede <mn.test3@gmail.com>
To: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I connecting AR6004 using SDIO and it is getting detected and proper
firmware is getting loaded to the chip. But it is not showing txpower,
bitrate, frequency. It shows like below:

wlan0     IEEE 802.11abg  ESSID:off/any
          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on


Another observation is that "WMI_BSSINFO_EVENTID" events are not
coming to driver. Any idea of such behavior.


Thanks,
Manohar.
