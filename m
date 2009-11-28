Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:33030 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZK1TdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 14:33:05 -0500
Received: by ewy7 with SMTP id 7so2937065ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 11:33:10 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: mac80211 not using get_tx_stats driver op?
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 28 Nov 2009 21:33:08 +0200
Message-ID: <87hbse8mx7.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I noticed that mac80211 is not calling get_tx_stats op anywhere. Is
there a plan to use it somehow or can we just remove it?

-- 
Kalle Valo
