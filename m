Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50455 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2JLUfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 16:35:09 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so3434056vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2012 13:35:08 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 12 Oct 2012 15:35:07 -0500
Message-ID: <CAMP=HhVfF863bwN1s0H+qtKEpKh9qBp5F-+9cvXBDCEABsE8gQ@mail.gmail.com> (sfid-20121012_223515_477822_10DB64F3)
Subject: rtl8191su nl80211
From: Mike Schliep <mike.schliep@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have Realtek Semiconductor Corp. RTL8191SU 802.11n WLAN Adapter I
want to work with nl80211. I have taken Joshua Roys work from May.

http://marc.info/?l=linux-wireless&m=133644367402433&w=2

With this patch set the driver is loaded when I plug the device in but
no wlan0 interface is created.
Can someone point me in the right direction on how to create a wlan0
interface with rtlwifi drivers so I can make this work?
