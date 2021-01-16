Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBD2C433DB
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Jan 2021 12:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 937E923118
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Jan 2021 12:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbhAPMwl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Jan 2021 07:52:41 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:36232 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbhAPMwl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Jan 2021 07:52:41 -0500
Received: from legolas.fritz.box (unknown [84.174.243.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id F127558007D;
        Sat, 16 Jan 2021 13:51:59 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH 0/4] Updates for rfkill
Date:   Sat, 16 Jan 2021 13:51:42 +0100
Message-Id: <20210116125146.31932-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

- Include older patch which updates rfkill.py to use Python 3 as
  the Python patch is based on this change.
- Update rfkill.h to include hard block reasons.
- Include support for hard block reasons to rfkill userspace.

Markus Theil (4):
  rfkill.py: migrate to python3
  rfkill: update rfkill.h
  rfkill: support hard block reason in python code
  rfkill: support hard block reason in C code

 rfkill.c  | 19 +++++++++++---
 rfkill.h  | 18 ++++++++++++-
 rfkill.py | 78 ++++++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 86 insertions(+), 29 deletions(-)

-- 
2.30.0

