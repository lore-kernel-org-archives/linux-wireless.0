Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from AShevkov.infinet.ru ([91.191.225.92]:57241 "EHLO
	ashevkov.infinet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3LPH3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 02:29:42 -0500
Date: Mon, 16 Dec 2013 13:29:09 +0600
From: Alex Hacker <hacker@epn.ru>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix band reporting for mgmt CCK frames on 5GHz
Message-ID: <20131216072909.GA19836@infinet.ru> (sfid-20131216_082946_165541_62252F0B)
References: <1386927883-14028-1-git-send-email-michal.kazior@tieto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1386927883-14028-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
If QCA98xx can receive CCK on 5GHz band (like all ath9k supported chips), I
want to ask: Is it should do that? I think no... It looks like FW bug.

Regards,
Alex.
