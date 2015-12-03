Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52327 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbbLCHHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 02:07:31 -0500
Received: from potku.adurom.net (a88-115-185-251.elisa-laajakaista.fi [88.115.185.251])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: kvalo@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id B58B91410F8
	for <linux-wireless@vger.kernel.org>; Thu,  3 Dec 2015 07:07:29 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: wlan0: set_features() failed (-1); wanted 0x0000000000004008, left 0x0000000000004808
Date: Thu, 03 Dec 2015 09:07:25 +0200
Message-ID: <87bna8f1si.fsf@kamboji.qca.qualcomm.com> (sfid-20151203_080736_612333_D9A94EEE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

For few weeks (I think) I have seen these kind of messages:

ath10k_pci 0000:02:00.0 wlan0: set_features() failed (-1); wanted 0x0000000000004008, left 0x0000000000004808

iwlwifi 0000:03:00.0 wlan0: set_features() failed (-1); wanted 0x0000000000004000, left 0x0000000000004800

I'm using ath.git master branch which is latest wireless-testing plus
latest ath patches. Any ideas what's causing these? mac80211 or
something else?

-- 
Kalle Valo
