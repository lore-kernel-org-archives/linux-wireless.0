Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cliff.cs.toronto.edu ([128.100.3.120]:36271 "EHLO
	cliff.cs.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab0BBS4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 13:56:31 -0500
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] airo: fix setting zero length WEP key 
In-reply-to: sgruszka's message of Tue, 02 Feb 2010 15:34:50 +0100.
             <1265121290-2969-1-git-send-email-sgruszka@redhat.com>
Date: Tue, 02 Feb 2010 13:32:41 -0500
From: Chris Siebenmann <cks@cs.toronto.edu>
Message-Id: <20100202183241.A529D2B0054@apps0.cs.toronto.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

| Patch prevents call set_wep_key() with zero key length. That fix long
| standing regression since commit c0380693520b1a1e4f756799a0edc379378b462a
| "airo: clean up WEP key operations". Additionally print call trace when
| someone will try to use improper parameters, and remove key.len = 0
| assignment, because it is in not possible code path.
| 
| Reported-and-bisected-by: Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
| Cc: Dan Williams <dcbw@redhat.com>
| Cc: <stable@kernel.org>
| Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Tested-by: Chris Siebenmann <cks@cs.toronto.edu>

(Tested on a Thinkpad T42, using current git tip + this patch; HEAD is
ab658321f32770b903a4426e2a6fae0392757755. This is the same machine I
bisected the problem on.)

	- cks
