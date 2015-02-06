Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38219 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbBFGnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 01:43:40 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: cw1200: use msecs_to_jiffies for conversion
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423035589-3647-1-git-send-email-hofrat@osadl.org>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Solomon Peachy <pizza@shaftnet.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Message-Id: <20150206064339.92EB9140C72@smtp.codeaurora.org> (sfid-20150206_074359_087877_FB3F368B)
Date: Fri,  6 Feb 2015 06:43:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This is only an API consolidation to make things more readable.
> Instances of  HZ / CONST  are replaced by appropriate msecs_to_jiffies().
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
