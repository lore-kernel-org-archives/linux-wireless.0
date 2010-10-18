Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46026 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0JRFzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 01:55:16 -0400
Date: Mon, 18 Oct 2010 03:55:40 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-2.6 2010-10-18
Message-ID: <20101018055540.GA13511@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Not sure if we still have time for a last minute fix, but here goes a
fix for a NULL dereference in L2CAP layer for 2.6.36-rc8. Please also let
me know if this is the right way to handle such last minute fix. Maybe you
should want this directly through Dave. 

Thanks.


The following changes since commit cd07202cc8262e1669edff0d97715f3dd9260917:

  Linux 2.6.36-rc8 (2010-10-14 16:26:43 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Nathan Holstein (1):
      Bluetooth: fix oops in l2cap_connect_req

 net/bluetooth/l2cap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
