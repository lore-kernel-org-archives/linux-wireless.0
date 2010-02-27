Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:52331 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030775Ab0B0USl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 15:18:41 -0500
Received: by ewy20 with SMTP id 20so636850ewy.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 12:18:39 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 27 Feb 2010 21:18:39 +0100
Message-ID: <753864a31002271218r7fce0601l51f78efdf2576f75@mail.gmail.com>
Subject: Status of http://patchwork.kernel.org/patch/56785/
From: Drapko Nitzhonot <drapkos@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I've been using this patch for over one month and it resolves my
problem with ath5k in AP mode.
Before patch, I got "ath5k phy0: no further txbuf available, dropping
packet" and I had to restart hostapd
to make it to work again.

Does anybody knows if this patch will be finally apply to kernel?

Thanks.
