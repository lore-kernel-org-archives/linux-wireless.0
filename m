Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54449 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbcFPOtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 10:49:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [4/4] rtl8xxxu: fix typo on variable name,
 compare against correct variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1465497530-18510-5-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	Colin Ian King <colin.king@canonical.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160616144935.36B2A613DE@smtp.codeaurora.org> (sfid-20160616_164939_053880_B39BFA7B)
Date: Thu, 16 Jun 2016 14:49:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> path_b_ok is being assigned but immediately after path_a_ok is being
> compared to the value 0x03.  This appears to be a typo on the
> variable name, compare path_b_ok instead.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 1 patch applied to wireless-drivers.git:

c70410cb91de rtl8xxxu: fix typo on variable name, compare against correct variable

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9167725/

