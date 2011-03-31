Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758226Ab1CaPnE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 11:43:04 -0400
Date: Thu, 31 Mar 2011 17:42:41 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: ec15e68ba6a regresion?
Message-ID: <20110331154232.GA7370@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seems commit:

commit ec15e68ba6a505631016f230899bafbb7b8cd0d6
Author: Jouni Malinen <jouni.malinen@atheros.com>
Date:   Wed Mar 23 15:29:52 2011 +0200

    cfg80211: Add nl80211 event for deletion of a station entry

is causing problems on my system. Sometimes when I disconnect
from wireless network, I can not connect again. Without commit
I can not reproduce the problem.

Stanislaw
