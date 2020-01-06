Return-Path: <SRS0=OLg+=23=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BBAC33C8C
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jan 2020 15:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00ED02072E
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jan 2020 15:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgAFPKb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Jan 2020 10:10:31 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:41872 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgAFPKb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Jan 2020 10:10:31 -0500
Received: from localhost.localdomain (unknown [141.24.207.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id C5389580068;
        Mon,  6 Jan 2020 16:10:29 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH 0/4] parse more events, updates for 5.5
Date:   Mon,  6 Jan 2020 16:10:20 +0100
Message-Id: <20200106151024.124315-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Markus Theil (4):
  iw: event: handle interface add/del
  iw: event: parse stop ap and frame wait cancel events
  update nl80211.h
  iw: info: add missing extended flags for 5.5

 event.c   | 36 +++++++++++++++++++++++++++++++-----
 info.c    |  7 +++++--
 nl80211.h | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 7 deletions(-)

--
2.24.1

