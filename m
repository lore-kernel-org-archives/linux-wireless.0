Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mhub5.vim.at ([92.43.99.6]:36679 "EHLO mail.vim.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755261Ab0BAP6o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 10:58:44 -0500
Subject: ath9k/PCI 168C:002C
From: Bernhard Reiter <ockham@raz.or.at>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 16:52:02 +0100
Message-ID: <1265039522.3610.55.camel@razor>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

i'm currently setting up karmic (64bit) an asus eeepc 1005p, and i've
found the following in the debian wiki:
http://wiki.debian.org/DebianEeePC/Model/1005P
i'm giving this laptop to another person on wednesday, but until then, i
might try to compile the ath9k module with the suggested addition of
that PCI id.

unfortunately, i haven't really found anything on how to do this (in a
least-invasive fashion). i've looked
into /usr/src/linux-headers-2.6.31-17/drivers/net/wireless/ath/ath9k,
but there's only a Kconfig and a Makefile, but no sources.

can you people help me modify, compile and test this module?

bernhard reiter
ps please cc, i'm not a list subscriber

