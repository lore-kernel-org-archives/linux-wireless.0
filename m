Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41919 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab1ECX5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:30 -0400
Received: by pzk9 with SMTP id 9so260225pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:29 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Thomas Pedersen <thomas@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: Support for secure mesh in userspace and other mesh fixes
Date: Tue,  3 May 2011 16:57:06 -0700
Message-Id: <1304467039-7730-1-git-send-email-javier@cozybit.com> (sfid-20110504_015736_950396_2BEDD9FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches add the capability of implementing the Authenticated Mesh Peering
Exchange entirely in userspace.  Open mesh networks can still be created
without the need of a userspace daemon.  For secured mesh networks, the daemon
takes control of the lifetime and the peer link state of mesh peers.

While working on this we encountered a few issues with the mesh stack which are
that are fixed in separate patches also included in this series.  

For a working userspace authentication daemon you can look at the ampe branch here: 
https://github.com/cozybit/authsae/tree/ampe

Cheers,

Javier

