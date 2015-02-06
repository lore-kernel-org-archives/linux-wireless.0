Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38308 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbBFGqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 01:46:51 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/3] orinoco: orinoco_plx use msecs_to_jiffies for conversion
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423037261-20193-1-git-send-email-hofrat@osadl.org>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Benoit Taine <benoit.taine@lip6.fr>,
	Bjorn Helgaas <bhelgaas@google.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Message-Id: <20150206064650.46D22140C91@smtp.codeaurora.org> (sfid-20150206_074706_757063_DEACE65E)
Date: Fri,  6 Feb 2015 06:46:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This is only an API consolidation and should make things more readable
> it replaces var * HZ / 1000 by msecs_to_jiffies(var).
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>

Thanks, 3 patches applied to wireless-drivers-next.git:

ab458cc85fa2 orinoco: orinoco_plx use msecs_to_jiffies for conversion
3427da4597ae orinoco: orinoco_pci use msecs_to_jiffies for conversion
c1f1f6663b3c orinoco: orinoco_tmd use msecs_to_jiffies for conversion

Kalle Valo
