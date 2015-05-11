Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36987 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbbEKKjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 06:39:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Okash Khawaja <okash.khawaja@gmail.com>
Cc: "joe\@perches.com" <joe@perches.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] adm8211: fix the possible pci cache line sizes inside switch-case
References: <20150505224020.GA3805@bytefire-computer>
	<87wq0ms3mv.fsf@kamboji.qca.qualcomm.com>
	<20150506063241.GA3042@bytefire-computer>
	<87k2wflj7p.fsf@kamboji.qca.qualcomm.com>
	<2CBE2DDF-92E5-45C9-95F8-C5CF918D12D9@gmail.com>
Date: Mon, 11 May 2015 13:38:58 +0300
In-Reply-To: <2CBE2DDF-92E5-45C9-95F8-C5CF918D12D9@gmail.com> (Okash Khawaja's
	message of "Mon, 11 May 2015 09:48:54 +0100")
Message-ID: <87vbfzjt4t.fsf@kamboji.qca.qualcomm.com> (sfid-20150511_123915_418626_EB2EB597)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okash Khawaja <okash.khawaja@gmail.com> writes:

> Sure, I'll create v2 of the patch with updated commit log. 
>
> Since it's part of a patch set, do you want me to send both the
> patches in the patch set together as v2 or just this patch?

Please resend the whole patchset as v2, less problems that way.

-- 
Kalle Valo
