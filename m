Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46565 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab2AMLy2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 06:54:28 -0500
Message-ID: <4F101B6D.2020405@qca.qualcomm.com> (sfid-20120113_125431_822970_BD00C388)
Date: Fri, 13 Jan 2012 13:54:21 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Remove useless initialization in ath6kl_read_fwlogs()
References: <1326360708-9362-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1326360708-9362-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2012 11:31 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> ath6kl_read_fwlogs() assigns the value zero to the variable 'ret'
> at the time of declaration. Later, return value of ath6kl_diag_read32()
> repalces the init value. Hence removing useless zero assignment.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, applied.

BTW, I only got patch 1/2. What happened to patch 2?

Kalle
