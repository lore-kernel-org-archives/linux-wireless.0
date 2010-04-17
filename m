Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50957 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab0DQCfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 22:35:11 -0400
Received: by pwj9 with SMTP id 9so2439005pwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 19:35:11 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 16 Apr 2010 19:34:51 -0700
Message-ID: <y2v43e72e891004161934w4687547cg3df4b75b0cc976b1@mail.gmail.com>
Subject: IRQ debugging with ath9k
To: Felix Fietkau <nbd@openwrt.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Often, the number of IRQs is not really something that will give you
good visibility to what's going on in the hardware. I typically want
to number of IRQs since my last monitor, the average and rate of
change. This is a pain in the ass to write in the driver so its better
to just suck out what you need from debugfs and then parse it at your
liking. I've written a perl script to do just this for IRQs for ath9k,
I figured I'll start stashing these things into a git repo for others
who might make some use of of this. Here it is:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/ath-utils.git

If you have something similar to parse debugfs send it my way, I can
stash it there. Similar scripts for parsing xmit stuff might come in
handy as well.

  Luis
