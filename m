Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2872 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758986AbZBLSjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 13:39:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/6] ath9k: regulatory cleanups
Date: Thu, 12 Feb 2009 13:38:52 -0500
Message-Id: <1234463938-1350-1-git-send-email-me@bobcopeland.com> (sfid-20090212_193923_306205_E057C4F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, here are some hopefully trivial cleanups to the existing ath9k
regulatory code.  This is the easy stuff before migrating regulatory
code to be shared with ath5k as well.  Next steps will be removing
usage of ath_hal from the common code, moving the files to a shared 
directory, and finally enabling the code in ath5k.

I only compile tested this for lack of hardware but there should
be 0 functional changes.

