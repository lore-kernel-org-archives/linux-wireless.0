Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:36218 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbbBCNh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 08:37:29 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/6] wil6210: remove old Tx work-around
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422780916-8577-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Message-Id: <20150203133729.6605A140DB1@smtp.codeaurora.org> (sfid-20150203_143741_856558_359C3E38)
Date: Tue,  3 Feb 2015 13:37:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In the Tx, work around used to force destination index 0
> to be used. This is no more necessary, as firmware supports
> multiple destinations
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks, 6 patches applied to wireless-drivers-next.git:

a3c74902082c wil6210: remove old Tx work-around
e59d16c08b3a wil6210: avoid Tx descriptor double write
5933a06dc96c wil6210: fix race between xmit and Tx vring de-allocation
5b29c573f3dc wil6210: more Tx debug
feeac225bed9 wil6210: print ciphers in debug info
7201472ed376 wil6210: Remove msm platform related code

Kalle Valo
