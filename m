Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54988 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab2DSI0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 04:26:23 -0400
Received: by iagz16 with SMTP id z16so11611557iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 01:26:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKa7sPSOBYmaoCRZZa=R0UT59bD+cxmtSPqxZ6754CmarNfXzA@mail.gmail.com>
References: <CAKa7sPSOBYmaoCRZZa=R0UT59bD+cxmtSPqxZ6754CmarNfXzA@mail.gmail.com>
From: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
Date: Thu, 19 Apr 2012 11:25:42 +0300
Message-ID: <CAKa7sPQYpgmh+=nLWGNzaXRL4_wHmpY4pScuwk4kTmYKCyU6dg@mail.gmail.com> (sfid-20120419_102632_506353_EA02EC68)
Subject: Rtlwifi with hostapd
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

I'm trying to run RTL8192DE-based wifi module in AP mode using hostapd.
RTL8192DE is connected to Marvell Kirkwood CPU using PCI Express bus.
But the kernel hangs right after hostapd was started.
In STA mode it is possible to scan for networks in 2.4 GHz band and it
discovers ~10 APs.
Was rtlwifi driver tested to work with hostapd?
I've tried compat-wireless-2011-12-01 and
92ce_se_de_linux_mac80211_0005.1230.2011.tar.gz from Realtek site.

--
Best regards,
Viktar Palstsiuk
