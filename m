Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63450 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab0LTRCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 12:02:40 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 09:02:24 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <kathy.giori@atheros.com>, <amod.bodas@atheros.com>,
	<david.quan@atheros.com>, <michael.green@atheros.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/8] wireless: DFS region support
Date: Mon, 20 Dec 2010 12:02:26 -0500
Message-ID: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series has a list of changes to kernel and userspace to start addressing
DFS region support. I've cheated and figured out a way to alter the current
regulatory database in such a way that it remains backwards compatible with
older databases so that no new CRDAs are required and we don't have to provide
two releases for old kernels and newer kernels for wireless-regdb updates.

In the end we end up passing the DFS region to the drivers. In terms of our DFS
development roadmap this covers parts I and II as promissed that I would take care
of by tomorrow, and leaves open now the chance for developers to start working
on part III: "Where do we stuff DFS parameters for each region":

http://wireless.kernel.org/en/developers/DFS

In tomorrow's meeting we can cover who is going to work on part III. People who
want to work on part III can start using these patches on their systems.

John, lets wait to merge these until Wednesday, I post these in patch form as I
think they are ready but tomorrow's discussions may push us to alter this a
bit, not sure. I will also review what we have done here with Michael Green so
he is on the same page.

  Luis
