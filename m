Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:28194 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbZDAUuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 16:50:44 -0400
Received: by yw-out-2324.google.com with SMTP id 5so218346ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Apr 2009 13:50:41 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 1 Apr 2009 16:50:41 -0400
Message-ID: <86201b3f0904011350o5b3fb48g811b57b3c4a1e602@mail.gmail.com> (sfid-20090401_225051_265370_58404EAB)
Subject: How to implement power save mode
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm working on a wireless driver that will use mac80211.  I'm trying
to understand what I need to do to support power save mode.  My
hardware has no built in support for power save mode other than the
ability to power it down.  Is there a driver that I can use as a model
for how to implement power save mode?

How is the IEEE80211_CONF_PS flag in the ieee80211_conf structure
used?  Does it indicate when the low level driver should be turning
the transceiver on and off, or is it just an indication of whether or
not the driver should be running in power save mode?

If the low level driver is suppose to implement the bulk of power save
mode, then how is it suppose to get information like how long the
sleep periods are suppose to be?  Does mac80211 provide utility
functions for parsing beacons to check for TIM and DTIM elements?

Any help you can provide would be appreciated.
