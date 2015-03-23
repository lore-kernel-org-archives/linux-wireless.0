Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:42377 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbCWSif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 14:38:35 -0400
Message-ID: <55105DA7.3040703@broadcom.com> (sfid-20150323_193839_072151_DB172886)
Date: Mon, 23 Mar 2015 19:38:31 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: broadcast ssid in scheduled scan
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes, Jouni,

I have noticed that under some circumstances wpa_supplicant initiates a 
scheduled scan with broadcast ssid. This is something our firmware can 
not do so could this be avoided? Maybe by adding a feature flag for it. 
I will look into it some more to understand the scenarios in which 
broadcast ssid is used in scheduled scan request. If you know about this 
feel free to let me know.

Regards,
Arend
