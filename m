Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:58294 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751944Ab1DKMSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 08:18:46 -0400
Subject: wlan power managment
From: Alexey Fisher <bug-track@fisher-privat.net>
To: power@bughost.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 11 Apr 2011 14:18:39 +0200
Message-ID: <1302524319.26801.22.camel@zwerg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo all,

i currently was busy with some wlan/VoIP issue, and collected some
questions/issues to you.

I know powertop give warning about some wlan settings like beacon
frequency and legacy power save, which use only PS-poll. But it is not
enough.

Newest AP can do more power saving for client, for example APSD
(scheduled and unscheduled). I think this need more advance tool than
powertop. Are any tool which can do fallowing:
It should check if associated AP support APSD (capability 5. bit). If
driver can work with it (all mac80211 based should do?). Statistic about
packets send S-APSD or U-APSD mode. QoS statistic and/or PID sending
packets with QoS markers (base, background, video, audio priority). We
should be able to find if VoIP fail because it use wrong QoS strategy or
AP or driver.

I think some/all of them are realistic but kernel is not ready for it?
Or kernel is ready but no tools? 

-- 
Regards,
        Alexey

