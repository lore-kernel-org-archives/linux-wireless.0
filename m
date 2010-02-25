Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab0BYMDj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 07:03:39 -0500
Subject: libertas_tf maintenance status
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 13:03:35 +0100
Message-ID: <1267099415.3796.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

What's the maintenance status on libertas_tf?

Now that we have async firmware loading that is more capable, I would
love to see libertas_tf converted to load firmware before registering
with mac80211, like ar9170 and iwlwifi, and register with the right MAC
address so we can get rid of the code that was added by

commit bdbe819540f3365249095692118dbfeee308140d
Author: Luis Carlos Cobo <luisca@cozybit.com>
Date:   Thu Aug 14 10:40:48 2008 -0700

    mac80211: allow no mac address until firmware load

johannes

