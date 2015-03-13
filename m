Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hofr.at ([212.69.189.236]:55356 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293AbbCMReI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 13:34:08 -0400
Date: Fri, 13 Mar 2015 18:34:05 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: match wait_for_completion_timeout return type
Message-ID: <20150313173405.GB9934@opentech.at> (sfid-20150313_183413_171876_87E92E9A)
References: <1426094076-10134-1-git-send-email-hofrat@osadl.org> <87y4n0q1rq.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87y4n0q1rq.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 13 Mar 2015, Kalle Valo wrote:

> Nicholas Mc Guire <hofrat@osadl.org> writes:
> 
> > Return type of wait_for_completion_timeout is unsigned long not int.
> > An appropriately named unsigned long is added and the assignments fixed up.
> >
> > Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> 
> Doesn't apply:
> 
> Applying: ath10k: match wait_for_completion_timeout return type
> fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/mac.c).
> Repository lacks necessary blobs to fall back on 3-way merge.
> Cannot fall back to three-way merge.
> Patch failed at 0001 ath10k: match wait_for_completion_timeout return type
>
sorry - no idea how I managed that - checking it.

Will fix it up and repost.

thx!
hofrat
