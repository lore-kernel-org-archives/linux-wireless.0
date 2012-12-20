Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:40395 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168Ab2LTPFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 10:05:22 -0500
Message-ID: <7d44469343059cc380b51910982d03fd.squirrel@www.infidigm.net> (sfid-20121220_160526_612970_18CAC351)
Date: Thu, 20 Dec 2012 10:51:28 -0500
Subject: Re: ath6kl in compat wireless supports AP mode?
From: drwho@infidigm.net
To: linux-wireless@vger.kernel.org, cash.q@hotmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cashq,

AR6003 is working for me with hostapd...

platform = arm imx51
kernel = 2.6.35.3-998
compat-wireless = "Backport based on linux-stable.git v3.4-rc3"
hostapd = v1.0

hostapd conf file
interface=wlan0
driver=nl80211
ssid=ATH6K_TEST
channel=1

I'm not creating a virtual interface wlan0.mon, just using wlan0.  Make
sure you have up-to-date ar6003 hw2.1.1 firmware from
git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

DrWho

