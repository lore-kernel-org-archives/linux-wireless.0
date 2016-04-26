Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50640 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbcDZJLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:11:17 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: rtl8821ae: Make sure loop counter is signed on
 allarchitectures
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460703025-2177-1-git-send-email-d.mueller@elsoft.ch>
To: =?utf-8?q?David_M=C3=BCller_=28ELSOFT_AG=29?= <d.mueller@elsoft.ch>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20160426091116.17FCA6120F@smtp.codeaurora.org> (sfid-20160426_111121_830284_87CE6D04)
Date: Tue, 26 Apr 2016 09:11:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The for-loop condition does not work correctly on architectures where
> "char" is unsigned. Fix it by using an "int", which may also result in
> more efficient code.
> 
> v2: Remove unneeded initialization.
> 
> Signed-off-by: David Müller <d.mueller@elsoft.ch>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
