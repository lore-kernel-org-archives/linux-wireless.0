Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:13790 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbbKSWFZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 17:05:25 -0500
Date: Thu, 19 Nov 2015 22:05:22 +0000
From: Jakub Kicinski <moorray3@wp.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 23/27] rt2x00: move under ralink vendor directory
Message-ID: <20151119220522.24fa2733@laptop> (sfid-20151119_230528_969900_5A94FC16)
In-Reply-To: <1447857966-19560-24-git-send-email-kvalo@codeaurora.org>
References: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
	<1447857966-19560-24-git-send-email-kvalo@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 18 Nov 2015 16:46:02 +0200, Kalle Valo wrote:
> Part of reorganising wireless drivers directory and Kconfig.
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

For Ralink you could probably drop the rt2x00 directory.  RaLink Tech.
doesn't exist any more and rt2x00 contains drivers for all of their
devices.

Obviously this is just a suggestion, not a show stopper.
