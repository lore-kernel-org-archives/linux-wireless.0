Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52493 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2CCLjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 06:39:08 -0500
Subject: mesh smatch (or sparse?) errors
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>,
	Javier Cardona <javier@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Mar 2012 12:39:06 +0100
Message-ID: <1330774746.3619.2.camel@jlt3.sipsolutions.net> (sfid-20120303_123910_951849_0BCF12EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   net/mac80211/mesh_pathtbl.c
net/mac80211/mesh_pathtbl.c:562 mesh_path_add() error: double lock 'bottom_half:'
net/mac80211/mesh_pathtbl.c:579 mesh_path_add() error: double unlock 'bottom_half:'
net/mac80211/mesh_pathtbl.c:588 mesh_path_add() error: double unlock 'bottom_half:'
net/mac80211/mesh_pathtbl.c:690 mpp_path_add() error: double lock 'bottom_half:'
net/mac80211/mesh_pathtbl.c:705 mpp_path_add() error: double unlock 'bottom_half:'
net/mac80211/mesh_pathtbl.c:714 mpp_path_add() error: double unlock 'bottom_half:'
net/mac80211/mesh_pathtbl.c:812 mesh_path_flush_by_nexthop() error: double lock 'bottom_half:'
net/mac80211/mesh_pathtbl.c:817 mesh_path_flush_by_nexthop() error: double unlock 'bottom_half:'
net/mac80211/mesh_pathtbl.c:885 mesh_path_del() error: double lock 'bottom_half:'
net/mac80211/mesh_pathtbl.c:899 mesh_path_del() error: double unlock 'bottom_half:'


johannes

