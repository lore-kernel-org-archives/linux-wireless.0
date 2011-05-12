Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65475 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab1ELRCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 13:02:24 -0400
Received: by vws1 with SMTP id 1so1255865vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 10:02:23 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 May 2011 19:02:23 +0200
Message-ID: <BANLkTi=pupNh=LMO-OEK+BbfNkpJz0nUkw@mail.gmail.com> (sfid-20110512_190228_467079_180A3394)
Subject: Setting my WiFi adhoc connection in power save mode
From: Jorge Miguel <jmiggal@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am trying to set power save mode in my Intel 3945ABG wireless card
under Ubuntu 10.10 - Maverick Meerkat and iwl3945 driver.

I need to set power save mode. In order to do so I tried to change
period and timeout options of iwconfig command so that beacon period
and ATIM window are changed.

For instance
:~$ sudo iwconfig wlan0 power period 2
    Error for wireless request "Set Power Management" (8B2C):
    SET failed on device wlan0 ; Invalid argument.

As you can see I get an error. Is it because it is not supported in my
card? Is there any way to set beacon interval and ATIM window
parameters?

Many thanks in advance,
Jorge
