Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47924 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab1CHCLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 21:11:37 -0500
Received: by pvg12 with SMTP id 12so813645pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2011 18:11:37 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Thomas Pedersen <thomas@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: 
Date: Mon,  7 Mar 2011 18:11:23 -0800
Message-Id: <1299550284-3167-1-git-send-email-javier@cozybit.com>
In-Reply-To: <1299354655.29845.8.camel@jlt3.sipsolutions.net>
References: <1299354655.29845.8.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

This is the peer discovery approach we had in mind.  As you see this brings
back the use of the AUTHENTICATED flag.  The idea is that unathenticated
stations are not considered new and won't trigger NEW_CANDIDATE notifications.

Suggestions appreciated.

