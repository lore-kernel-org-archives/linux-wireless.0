Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.slscorp.com ([198.245.63.119]:56515 "EHLO
	ns4000790.ip-198-245-63.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965088Ab3IELd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 07:33:29 -0400
Message-ID: <52286C01.6080303@slscorp.com> (sfid-20130905_133332_633842_C0B83CF2)
Date: Thu, 05 Sep 2013 17:03:21 +0530
From: Abbas Chunawala <abbas.chunawala@slscorp.com>
Reply-To: abbas.chunawala@slscorp.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Error:ACS not working even after the Makefile and the configuration
 options are set.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
Greetings.

No ACS prints.
Instead an error
ath0 : IEEE 802.11 : Fetching channel rate/frequency not supported
The channel variable is set right in the configuration file.
How to get the acs prints.
The command for the hostapd invocation is a s follows:-
hostapd -B /tmp/secath0 -dd -e /etc/wpa2/entropy.

Thanks
Regards
Abbas Chunawala
(System Level Solutions (I) Pvt. Ltd. )


