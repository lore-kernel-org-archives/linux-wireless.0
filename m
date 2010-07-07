Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28675 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445Ab0GGPtZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 11:49:25 -0400
Subject: Localversion broken in 2.6.35-rc4, please cherrypick 7263e715
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 07 Jul 2010 11:49:20 -0400
Message-Id: <1278517760.8598.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

The localversion is not appended for builds outside the source tree.
The fix is in the mainline already, commit 7263e715.  I think it should
be cherrypicked for convenience of wireless developers.

Those of us using StGIT can use
stg pick -n localversion-srctree 7263e715

-- 
Regards,
Pavel Roskin
