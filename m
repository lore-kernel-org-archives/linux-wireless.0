Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:56507 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab2FUMDk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 08:03:40 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC v2] initial channel context implementation
Date: Thu, 21 Jun 2012 14:03:29 +0200
Message-ID: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com> (sfid-20120621_140342_835587_B1920776)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's my respin of channel contexts patches. Thanks for the
review on the previous version.

Changes in short:

 * renamed to chanctx (to avoid very_long_structure_names)
 * pub/priv part added (and drv_priv)
 * new mutex added
 * channel contexts are a linked list
 * tracing added

Next step would be to refactor mac80211 codepaths to take
advantage of channel contexts (if used).


-- Pozdrawiam / Best regards, Michal Kazior.

