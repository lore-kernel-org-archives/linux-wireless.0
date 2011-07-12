Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:48379 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab1GLHwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 03:52:46 -0400
From: Sven Neumann <s.neumann@raumfeld.com>
To: libertas-dev@lists.infradead.org
Cc: daniel@zonque.org, linux-wireless@vger.kernel.org
Subject: patch to fix potential problem with wiphy_update_regulatory (update)
Date: Tue, 12 Jul 2011 09:52:38 +0200
Message-Id: <1310457159-16698-1-git-send-email-s.neumann@raumfeld.com> (sfid-20110712_095249_046902_BB95A2AA)
In-Reply-To: <1310456639-16468-1-git-send-email-s.neumann@raumfeld.com>
References: <1310456639-16468-1-git-send-email-s.neumann@raumfeld.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I am sorry, I've picked up the wrong version of the patch. In order
to compile the functions need to be reordered a little. Here's an
updated version that actually compiles (and works for me).


Regards,
Sven
