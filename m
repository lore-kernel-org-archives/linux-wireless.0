Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41486 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab1EQK2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 06:28:30 -0400
Received: by vxi39 with SMTP id 39so211663vxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 03:28:30 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 May 2011 12:28:29 +0200
Message-ID: <BANLkTim9NtWtXzM0Q2t-JiGY8VfzsdCZZA@mail.gmail.com> (sfid-20110517_122843_702007_29C2D4B3)
Subject: Obtain station_info from kernel space
From: Daniele Furlan <daniele.furlan@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
is there a way to obtain station_info from kernel space accessing to
cfg80211_ops?
>From user space nl80211 can be used and offer a wide compatibility,
but from kernel space I'm not able to find a way that works for all
cfg80211 drivers.

Thanks in advance.

-- 
Daniele Furlan
