Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62843 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab2F2KrW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 06:47:22 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] respect channels in iface combinations
Date: Fri, 29 Jun 2012 12:46:55 +0200
Message-ID: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com> (sfid-20120629_124727_389140_9A78C919)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patchset introduces channel tracking per interface which is needed
to start enforcing num_different_channels in interface combinations.
Changes to monitor mode behaviour is also required for sane channel
accounting (considering how mac80211 handles monitor interfaces).

This prepares cfg80211 for multi-channel operation.

Remaining issue that needs addressing at a later time is CSA handling
(which is already broken anyway).

Changes since PATCH v1:
 * rebased on top of mac80211-next tree from 2012-06-29


-- Pozdrawiam / Best regards, Michal Kazior.

