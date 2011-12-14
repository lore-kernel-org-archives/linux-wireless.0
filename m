Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35467 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab1LNL3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 06:29:52 -0500
Subject: Re: [PATCH 0/5] station management rework
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20111214112026.409514167@sipsolutions.net> (sfid-20111214_122400_723641_73C1DD48)
References: <20111214112026.409514167@sipsolutions.net>
	 (sfid-20111214_122400_723641_73C1DD48)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 12:29:50 +0100
Message-ID: <1323862190.3380.6.camel@jlt3.sipsolutions.net> (sfid-20111214_123000_472902_38ADDCDA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops, please drop this for now -- the might_sleep() warning can trigger
in IBSS mode, sorry!

johannes

