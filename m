Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60720 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbbEZOMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 10:12:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: reduce severity of debug messages for mgmt rx
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1432119966-2275-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <quozl@laptop.org>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150526110825.4C827141808@smtp.codeaurora.org> (sfid-20150526_161308_374660_F08F1A13)
Date: Tue, 26 May 2015 11:08:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This would ensure dmesg logs are not spammed with "unknown mgmt frame
> subtype" messages.
> 
> Reviewed-by: James Cameron <quozl@laptop.org>
> Signed-off-by: Avinash Patil <patila@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
