Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49167 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab1LTO4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 09:56:31 -0500
Received: by yhr47 with SMTP id 47so4725106yhr.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 06:56:30 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH 0/2] NFC: update to NCI spec 1.0 draft 22
Date: Tue, 20 Dec 2011 16:57:39 +0200
Message-Id: <1324393061-32173-1-git-send-email-ilane@ti.com> (sfid-20111220_155634_827317_E04E3DC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

This series of patches update the supported features according to 
NCI spec 1.0 draft 22. No new features were introduced.
The changes are related only to the NCI protocol layer.
NCI spec 1.0 draft 22 should be the final version.

Summary of the main changes:
- Addition, deletion, and modification of NCI constants
- Changes in NCI commands, responses and notifications structures
- Handle error during NCI data exchange

Ilan Elias (2):
  NFC: Update names and structs to NCI spec 1.0 d22
  NFC: Handle error during NCI data exchange

 include/net/nfc/nci.h      |   49 ++++++++++++++++++-------------------------
 include/net/nfc/nci_core.h |    6 +++-
 net/nfc/nci/core.c         |   22 ++++++++++---------
 net/nfc/nci/lib.c          |    3 --
 net/nfc/nci/ntf.c          |   44 ++++++++++++++++++++++++++++++++-------
 net/nfc/nci/rsp.c          |   10 ---------
 6 files changed, 73 insertions(+), 61 deletions(-)

