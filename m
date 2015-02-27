Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34203 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbbB0IHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 03:07:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: libertas: remove unnecessary check before calling debugfs_remove
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423643586-11002-1-git-send-email-baspeters93@gmail.com>
To: Bas Peters <baspeters93@gmail.com>
Cc: Bas Peters <baspeters93@gmail.com>, linville@tuxdriver.com,
	johannes.berg@intel.com, dcbw@redhat.com,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20150227080720.BA59C13FA62@smtp.codeaurora.org> (sfid-20150227_090741_474336_BEBB6591)
Date: Fri, 27 Feb 2015 08:07:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Debugfs_remove will check for error or NULL for us, so it is not
> necessary to do this here.
> 
> Signed-off-by: Bas Peters <baspeters93@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
