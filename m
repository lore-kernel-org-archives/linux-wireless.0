Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2226 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556Ab3BYOSx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 09:18:53 -0500
Message-ID: <512B72BE.5050808@broadcom.com> (sfid-20130225_151858_670233_272AD3BD)
Date: Mon, 25 Feb 2013 15:18:38 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmsmac: export firmware version to ethtool
References: <1361720494-27131-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1361720494-27131-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/24/13 16:41, Hauke Mehrtens wrote:
> This exports the firmware version in use to userspace through ethtool.
>
> root@OpenWrt:/# ethtool -i wlan0
> firmware-version: 610.812

This info is already available under debugfs although I prefer your 
formatting :-) :

$ sudo cat hardware
board vendor: 1028
board type: e
board revision: 2203
board flags: 200
board flags2: 1000
firmware revision: 262032c

Gr. AvS

