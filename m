Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:35119 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354AbZACSsY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 13:48:24 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LJBXm-0004Uj-O7
	for linux-wireless@vger.kernel.org; Sat, 03 Jan 2009 18:48:18 +0000
Received: from 77.21.169.220 ([77.21.169.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 18:48:18 +0000
Received: from feldmann_markus by 77.21.169.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 18:48:18 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Re: Do not get BCM4303 to work
Date: Sat, 03 Jan 2009 19:49:36 +0100
Message-ID: <gjobt8$v22$1@ger.gmane.org> (sfid-20090103_194826_279281_BB859D2B)
References: <ga2fra$9q$1@ger.gmane.org> <gjob72$t2j$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <gjob72$t2j$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I forgot to wrote my Kernel Options
CONFIG_LEDS_CLASS=m
CONFIG_LEDS_TRIGGERS=y
CONFIG_MAC80211_LEDS=y

CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_INPUT_POLLDEV=m

My b43legacy Driver is built as modul.

Regards Markus

