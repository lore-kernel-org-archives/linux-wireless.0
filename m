Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31302 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2DWLjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 07:39:49 -0400
Message-ID: <4F953F81.5050202@qca.qualcomm.com> (sfid-20120423_133952_601487_7F7C97A5)
Date: Mon, 23 Apr 2012 14:39:45 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: unblock fwlog_block_read() on exit
References: <1334946787-10784-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1334946787-10784-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/20/2012 09:33 PM, Thomas Pedersen wrote:
> Complete the waiting fwlog_block_read on debugfs cleanup, otherwise
> userspace and module unload might softlock.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied.

Kalle
