Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbcCKT5f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 14:57:35 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 0/7] rtl8xxxu: Improve handling of new TX descriptor format
Date: Fri, 11 Mar 2016 14:57:27 -0500
Message-Id: <1457726254-28178-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160311_205744_267667_947A3A22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Given the 8723bu set of patches made it into the tree, here is a much
smaller set which improves the handling of the gen2 40 byte TX
descriptor format.

Cheers,
Jes


Jes Sorensen (7):
  rtl8xxxu: Change name of struct tx_desc to be more decriptive
  rtl8xxxu: Rename TX descriptor bits to map them to 32/40 byte
    descriptors
  rtl8xxxu: Correct txdesc40 gid definition
  rtl8xxxu: TXDESC_SHORT_GI is txdesc32 only
  rtl8xxxu: 8192eu uses txdesc40
  rtl8xxxu: Update some register definitions
  rtl8xxxu: Use enums for chip version numbers

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 157 ++++++++++-----------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   | 130 ++++++++++-------
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  31 +++-
 3 files changed, 176 insertions(+), 142 deletions(-)

-- 
2.5.0

