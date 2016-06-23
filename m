Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbcFWSf5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 14:35:57 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 0/4] rtl8xxxu: minor fixes
Date: Thu, 23 Jun 2016 14:35:51 -0400
Message-Id: <1466706955-10339-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160623_203606_234072_9A9E032E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This is a couple of minor fixes for the rtl8xxxu driver. Nothing crazy
urgent, but nice to get in anyway.

Cheers,
Jes


Jes Sorensen (3):
  rtl8xxxu: Reduce console noise when removing the kernel module
  rtl8xxxu: Mark 0x20f4:0x648b as tested
  rtl8xxxu: Mark 0x2001:0x3308 as tested

Luis de Bethencourt (1):
  rtl8xxxu: remove unneeded assignments

 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c   |  2 --
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    | 20 +++++++++++++++-----
 2 files changed, 15 insertions(+), 7 deletions(-)

-- 
2.7.4

