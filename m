Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33652 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab1CURtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 13:49:53 -0400
Received: by vxi39 with SMTP id 39so5202581vxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 10:49:52 -0700 (PDT)
Message-ID: <4D878FBC.5010204@lwfinger.net>
Date: Mon, 21 Mar 2011 12:49:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Logs spammed by brcm80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With both BCM4313 and BCM943224 cards, brcm80211 spams my logs with messages:

wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 159/256 dur 1778/1504
wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 137/256 dur 1602/1504
wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 382/256 dur 3562/1504

Thanks,

Larry
