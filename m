Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39474 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbcGHJyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 05:54:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] rtl8xxxu: remove unneeded assignments
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1466706955-10339-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160708095440.7637860F71@smtp.codeaurora.org> (sfid-20160708_115444_670381_1B1896FB)
Date: Fri,  8 Jul 2016 09:54:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Luis de Bethencourt <luisbg@osg.samsung.com>
> 
> reg_eac and reg_ecc are only used if candidate is bigger than 0, and in
> that case new values will be given to them. Removing the unused
> assignments.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

efcb32883f36 rtl8xxxu: remove unneeded assignments
78383ac95181 rtl8xxxu: Reduce console noise when removing the kernel module

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9195753/

