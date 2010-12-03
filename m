Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab0LCI10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 03:27:26 -0500
Message-Id: <20101203082039.131181927@sipsolutions.net>
Date: Fri, 03 Dec 2010 09:20:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] mesh improvements
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok so this is the final versions of the mesh
patches we've been working on.

I replaced my first patch with Javier's, so
that we no longer hardcode any TTL but the
element TTL is also configurable.

Now you can join/leave meshes on the fly, and
we can work on adding more setup to creating
the mesh, like the beacon IEs Javier had an
interest in. Another easy target would be the
beacon interval, for example.

I think eventually this should be extended a
bit further in that drivers would need the
ability to advertise which of the mesh config
parameters they support. mac80211 currently
supports all of them, but I could see that
change with newer drafts, and I can also see
not all devices (like libertas...) supporting
all possible parameters.

johannes
