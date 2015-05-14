Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hofr.at ([212.69.189.236]:47877 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030209AbbENRk2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 13:40:28 -0400
Date: Thu, 14 May 2015 19:40:25 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: wmi: match wait_for_completion_timeout
	return type
Message-ID: <20150514174025.GA22524@opentech.at> (sfid-20150514_194055_081096_CE54FFF3)
References: <1431621821-8173-1-git-send-email-hofrat@osadl.org> <87fv6zccny.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87fv6zccny.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 14 May 2015, Kalle Valo wrote:

> Nicholas Mc Guire <hofrat@osadl.org> writes:
> 
> > Patch is against 4.1-rc3 (localversion-next is -next-20150514)
> 
> BTW, this info should be under "---" line so that it doesn't get stored
> to the actual commit log.
>
that is where I had been putting it until ask by Josh Triplett and 
Steven Rostedt to put it above the "---" line explicitly
see: http://lkml.org/lkml/2015/5/11/552 

So now I'm a bit lost where to actually put this buildtest info ?

thx!
hofrat
