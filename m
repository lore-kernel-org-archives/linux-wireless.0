Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:17418 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbYJMWK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 18:10:59 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1424539fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2008 15:10:58 -0700 (PDT)
Message-ID: <30353c3d0810131510x4e06d4bes2d36a3e08f29df56@mail.gmail.com> (sfid-20081014_001104_524154_DC3968B7)
Date: Mon, 13 Oct 2008 18:10:58 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: linux-wireless@vger.kernel.org,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: [PATCH 0/2] stk-webcam updates
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following series of patches address issues in the current
for_linus branch of the mchehab's linux-2.6 tree.

1. Minor corrections to mercurial revision 9034 which was a patch
submitted for testing.
2. Corrects a crash in stk-webcam during close if the camera has been
disconnected while open.

These patches have been well tested and should be applied for 2.6.28

Regards,

David Ellingsworth
