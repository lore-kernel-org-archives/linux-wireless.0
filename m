Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43127 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab1HYBWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:22:06 -0400
Received: by gya6 with SMTP id 6so1330019gya.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:22:05 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 0/8] FIXUP: mesh gates
Date: Wed, 24 Aug 2011 18:21:45 -0700
Message-Id: <1314235313-4564-1-git-send-email-thomas@cozybit.com> (sfid-20110825_032214_606848_F197965C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since v1 of the mesh gate series was accidentally applied, revert the relevant
v1s and apply the v2s.

Javier Cardona (8):
  Revert "{nl,cfg,mac}80211: let userspace make meshif mesh gate"
  Revert "{nl,cfg,mac}80211: let userspace set RANN interval"
  Revert "mac80211: mesh gate implementation"
  Revert "mac80211: fix mpath timer NULL function"
  mac80211: fix mpath timer removal
  mac80211: mesh gate implementation
  {nl,cfg,mac}80211: let userspace set RANN interval
  {nl,cfg,mac}80211: let userspace make meshif mesh gate

 net/mac80211/cfg.c          |    8 ++++++++
 net/mac80211/mesh.c         |    4 ++--
 net/mac80211/mesh_pathtbl.c |   10 ++++------
 3 files changed, 14 insertions(+), 8 deletions(-)

-- 
1.7.4.1

