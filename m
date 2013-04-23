Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39975 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab3DWIpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 04:45:40 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20854.18866.135251.330099@gargle.gargle.HOWL> (sfid-20130423_104547_224154_21DA03C8)
Date: Tue, 23 Apr 2013 14:13:30 +0530
To: Gerry Gavigan <gerry@gavigan.f9.co.uk>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: ath9k problems on openSUSE 12.3
In-Reply-To: <d5546f49ab812cc89887b18b41d44da0@imap.force9.net>
References: <d5546f49ab812cc89887b18b41d44da0@imap.force9.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gerry Gavigan wrote:
> 02:00.0 Network controller [0280]: Atheros Communications Inc. AR9485 
> Wireless Network Adapter [168c:0032] (rev 01)

As a first step, can you disable Power Save and see if the issue persists ?
("iw dev wlan# set power_save off" and verify that "iw wlan0 get power_save" shows "off").

Sujith
