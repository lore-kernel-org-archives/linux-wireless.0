Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57940 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1IPP7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 11:59:01 -0400
Message-ID: <4E737241.2080301@qca.qualcomm.com> (sfid-20110916_175906_929689_FD491149)
Date: Fri, 16 Sep 2011 18:58:57 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath9k_htc: "No free RX buffer" in monitor mode
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was testing monitor mode with ath9k_htc and my laptop got slower. Then
I noticed this:

[ 9246.606150] ath: No free RX buffer
[ 9246.606156] ath: No free RX buffer
[ 9246.606582] ath: No free RX buffer
[ 9246.606590] ath: No free RX buffer

And I saw it quite a lot:

$ grep "ath: No free" /var/log/syslog | wc -l
870950

Kalle
