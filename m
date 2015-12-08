Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35458 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbbLHEyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 23:54:12 -0500
Date: Tue, 8 Dec 2015 10:24:04 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Fixing full name in patchwork
Message-ID: <20151208045404.GB23610@sudip-pc> (sfid-20151208_055431_728636_EE82EF95)
References: <1448281922-20382-1-git-send-email-sudipm.mukherjee@gmail.com>
 <87zixmb0fp.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87zixmb0fp.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 07, 2015 at 08:03:54PM +0200, Kalle Valo wrote:
> Hi Sudip,
> 
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:
> 
> > We were dereferencing cmd first and checking for NULL later. Lets first
> > check for NULL.
> >
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> 
> I noticed that your name in git log is not your full name:
> 
> commit 0a38c8e1b592c16d959da456f425053e323a5153
> Author: sudip <sudipm.mukherjee@gmail.com>
> Date:   Tue Nov 24 13:51:38 2015 +0530
> 
> This is because for some reason in patchwork your fullname is just
> "sudip":
> 
> https://patchwork.kernel.org/patch/7688171/
> 
> Could you please fix your name in patchwork so that in the future we can
> use your correct full name? The problem is that I don't know exactly how
> to do this but it should be possible because I remember someone else
> having a similar problem and he was able to fix it.

Hi Kalle,
I have also noticed the patch. Anyway, I have created a profile in
patchwork and given full name. Hopefully that should solve the problem.


regards
sudip
