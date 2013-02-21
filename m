Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:3202 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759427Ab3BUUfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 15:35:19 -0500
Message-ID: <a846efff4d70649a69966a63a24fba37.squirrel@www.infidigm.net> (sfid-20130221_213752_234794_024683E7)
Date: Thu, 21 Feb 2013 16:36:11 -0500
Subject: ath6kl: AR6004 missing firmware
From: drwho@infidigm.net
To: linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com, ath6kl-devel@qca.qualcomm.com,
	mohammed@qca.qualcomm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have an AR6004 hw1.1 usb.  The ath6kl driver is looking for its firmware
in ath6k/AR6004/hw1.1.  Pulling from

git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

today only has firmware for hw1.2 and hw1.3.  I also have an AR6004 hw1.3
usb and it is working fairly well with the same kernel I've built from
Kalle Valo git.  I'm assuming hw1.1 is newer?

Jon

