Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:45085 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab3AYK5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:57:22 -0500
Received: by mail-lb0-f179.google.com with SMTP id j14so481551lbo.10
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 02:57:18 -0800 (PST)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Unable to set HT40 for ath9k
Date: Fri, 25 Jan 2013 11:57:15 +0100
Message-ID: <3156554.OnlXenjCFv@sylvesterjr.pats.ua.ac.be> (sfid-20130125_115727_883785_D5758769)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I have been trying to set up a wireless network (tested both managed 
and ad-hoc mode) with HT40 enabled using Atheros chipsets and thus 
the ath9k driver. In both cases, iw responded with:
Command failed: Invalid argument (-22)

when e.g. executing the command:
iw dev wlan0 ibss join network 5180 HT40+

Is this not implemented or is this a (known) bug?

System: 
Linux OpenWrt 3.3.8
driver: ath9k

Best regards,
Erwin



