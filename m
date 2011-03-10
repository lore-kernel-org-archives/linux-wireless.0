Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49139 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1CJShh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 13:37:37 -0500
Received: by gyh20 with SMTP id 20so797018gyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 10:37:36 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 10 Mar 2011 19:37:36 +0100
Message-ID: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>
Subject: Status of Broadcom 4353?
From: "Chen, Xianwen" <xianwen.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

Thanks for keeping up good work on wireless support in Linux all these
years. I can still recall the joy when Realtek 8187 became part of
kernel supported driver a few years ago -- it actually was the main
reason I switched from NetBSD to Linux.

I now have a laptop from my employer, on which I sneaked Linux in. The
issue is that the wireless adapter seems not to be recognized:

lspci -vnn | grep 14e4
>> 02:00.0 Network controller [0280]: Broadcom Corporation Device [14e4:4353] (rev 01)

Though the new Broadcom driver seems to be more appropriate, I
actually compiled both the old and the new drivers. Further reading on
  http://linuxwireless.org/en/users/Drivers/brcm8021
and
  http://wireless.kernel.org/en/users/Drivers/b43
suggests that 4353 is not currently supported! :-(

What is the current status of Broadcom 4353? I'm curious and actually
eager to know. Any information will be appreciated!

Have a good day fellas!

Xianwen
