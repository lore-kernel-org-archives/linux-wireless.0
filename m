Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38827 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1DADMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 23:12:47 -0400
Received: by eyx24 with SMTP id 24so921537eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 20:12:45 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 31 Mar 2011 23:12:45 -0400
Message-ID: <AANLkTi=pWrS9jK1obHLiXu+oLK6YS00fG-YQqzUieYH7@mail.gmail.com>
Subject: bad packets in monitor mode with ar9170 devices
From: Realman Namingston <realname1776@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ar9170-based devices record a fair amount of bad packets in monitor
mode both with the old ar9170usb and new carl9170 drivers. The packets
contain random BSSIDs, some measure of additional random data, and
seem to scale proportional to the amount of traffic occurring on the
observed channel. This behavior makes the devices rather unattractive
for use in Kismet and site survey applications.

I assume this is due to a shortcoming of the hardware.. but is there
any potential fix possible?

-r1776
