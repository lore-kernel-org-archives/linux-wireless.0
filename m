Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:28266 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbAZUoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 15:44:10 -0500
Message-ID: <54C6A717.5050804@broadcom.com> (sfid-20150126_214414_097784_ACEF0A96)
Date: Mon, 26 Jan 2015 21:44:07 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: cfg80211: Unknown symbol get_net_ns_by_fd (err 0)
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

The commit below causes the error mentioned in the Subject: field. I 
would like to fix this, but could use a bit of help here how to do this 
type of things.

commit 4b681c82d2f9bef121c912ffcaac89a004af3f2c
Author: Vadim Kochan <vadim4j@gmail.com>
Date:   Mon Jan 12 16:34:05 2015 +0200

     nl80211: Allow set network namespace by fd

Regards,
Arend
