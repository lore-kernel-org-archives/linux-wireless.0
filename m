Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47798 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbcDNNDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 09:03:44 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/5] mwifiex: missing break statement
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460386361-29918-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160414130338.3103060CF4@smtp.codeaurora.org> (sfid-20160414_150348_051357_50DB9299)
Date: Thu, 14 Apr 2016 13:03:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This patch adds missing break statement at the end of
> PCIE_DEVICE_ID_MARVELL_88W8897 switch section.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 5 patches applied to wireless-drivers-next.git:

c865a70098d9 mwifiex: missing break statement
e87650bce9a5 mwifiex: add pcie usb/uart firmware download support
b9db39787933 mwifiex: add default setting for pcie firmware download
c3ec0ff6425b mwifiex: do not wait on semaphore during card removal
bcc920e8f083 mwifiex: fix incorrect ht capability problem

Kalle Valo
