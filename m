Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42036 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbbJ1SzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 14:55:18 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] airo: Track APList_rid in struct airo_info
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1445022254-30428-1-git-send-email-linux@rainbow-software.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>
Message-Id: <20151028185517.BA91114151F@smtp.codeaurora.org> (sfid-20151028_195615_196588_DA4083EF)
Date: Wed, 28 Oct 2015 18:55:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Instead of dynamically allocating APList, make it a member of struct
> airo_info to always track state of APList_rid.
> This simplifies suspend/resume and allows removal of readAPListRid.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Thanks, 2 patches applied to wireless-drivers-next.git:

f675f93a797a airo: Track APList_rid in struct airo_info
dae0412d0caa airo: fix scan after SIOCSIWAP (airo_set_wap)

Kalle Valo
