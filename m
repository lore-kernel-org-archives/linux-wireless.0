Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11873 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994Ab2GLHMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 03:12:38 -0400
Message-ID: <4FFE78DF.1060108@qca.qualcomm.com> (sfid-20120712_091241_984092_0B63BEFF)
Date: Thu, 12 Jul 2012 10:12:31 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Make use of return value from ath6kl_diag_read()
References: <1341991303-1034-1-git-send-email-c_ppitch@qca.qualcomm.com>
In-Reply-To: <1341991303-1034-1-git-send-email-c_ppitch@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2012 10:21 AM, Pandiyarajan Pitchaimuthu wrote:
> In ath6kl_read_fwlogs(), return value from ath6kl_diag_read()is not
> used to bail out in case of any errors in reading fw log. No real issue
> is observed because of this, reported by source code analyzer.
> 
> Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>

Thanks, applied. I just fixed a checkpatch warning about too long line.

But please CC ath6kl-devel and kvalo@qca.qualcomm.com when submitting
ath6kl patches. It makes it easier for me to track patches.

Kalle
