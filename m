Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57474 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005AbZBRV36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 16:29:58 -0500
Message-ID: <499C7DC0.4040608@lwfinger.net> (sfid-20090218_223003_187966_416E23D4)
Date: Wed, 18 Feb 2009 15:29:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: ieee80211_regdom module parameter for cfg80211
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On at least one forum, I have seen the recommendation that a user set their
regulatory domain by creating the file /etc/modprobe.d/cfg80211 with the
contents "ieee80211_regdom=US".

That works as long as CONFIG_WIRELESS_OLD_REGULATORY is set in their .config,
but will fail if it is not.

Should the module_param statement be moved outside the ifdef
CONFIG_WIRELESS_OLD...? Setting the module parameter that way might not make any
sense, but it surely shouldn't kill wireless.

Larry


