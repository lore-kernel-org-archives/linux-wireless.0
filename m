Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:64007 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLWPcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 10:32:09 -0500
Received: by mail-ig0-f169.google.com with SMTP id hl2so6861468igb.4
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 07:32:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54991B32.2010105@rempel-privat.de>
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>
	<54991B32.2010105@rempel-privat.de>
Date: Tue, 23 Dec 2014 10:31:59 -0500
Message-ID: <CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com> (sfid-20141223_163212_534290_9535C121)
Subject: Re: bug report for ath9k_htc driver
From: Jeremy Audet <ichimonji10@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oleksij,

Sure thing. I cloned your ath9k-htc-firmware-blob repository and
copied the htc_9271.fw file to /usr/lib/firmware/. I then plugged in
the TL-WN722N USB adapter, brought up the wireless device with `sudo
ip link set dev wlp0s18f2u4 up; echo $?` (return code 0), and sat back
and waited. I did not interact with the machine beyond keeping open an
SSH session (via a wired interface) and watching the log file. About
five minutes later, a similar error occurred as described in my
previous email.

I've collected some logging output with the command `journalctl -k
--since=today`. You may find this log a bit more useful than the dmesg
log linked to in my previous email. You can find the log here:
http://www.ichimonji10.name/downloads/tl-wn722n-journalctl.txt

-Jeremy "Ichimonji10" Audet
