Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41100 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbbLKLYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 06:24:50 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/6] mwifiex: parse adhoc start/join result
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1449238387-27396-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20151211112449.79508141ADF@smtp.codeaurora.org> (sfid-20151211_122453_161526_4C5EBC64)
Date: Fri, 11 Dec 2015 11:24:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Even if ADHOC start or join attempt is failed, these commands
> are returned with success status by firmware. Actual connection
> result is provided inside command response.
> 
> This patch parses the adhoc connection result and resets
> connection state variables if connection is not successful.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, 5 patches applied to wireless-drivers-next.git:

d5556e87610e mwifiex: parse adhoc start/join result
d2b0c735ebac mwifiex: handle start AP error paths correctly
658cb59232b1 mwifiex: set regulatory info from EEPROM
947d315257f9 mwifiex: don't follow AP if country code received from EEPROM
7cfd829cfe55 mwifiex: correction in region code to country mapping

Kalle Valo
