Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:8447 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbbFIJTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 05:19:33 -0400
Message-ID: <5576AFA2.9090004@broadcom.com> (sfid-20150609_111936_459350_BB75B5DA)
Date: Tue, 9 Jun 2015 11:19:30 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: about .dump_station() callback
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I am looking in get_station() and consequently dump_station() callback 
for our brcmfmac driver. The latter is called with index. Can I expect 
this to be starting at 0 and iterate through or can it be requested in 
any order.

Regards,
Arend
