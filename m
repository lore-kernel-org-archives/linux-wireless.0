Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52025 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbcGHGyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 02:54:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: Replace warning with an error message if HTT op
 version is unset
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1466700001-4883-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <f38889b09514441d82aef5559b645dc2@euamsexm01a.eu.qualcomm.com> (sfid-20160708_085413_725208_DAC64694)
Date: Fri, 8 Jul 2016 08:54:02 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Print an ath10k error message rather a call trace when HTT op version is
> not found from firmware META data (IE). This should be sufficient to figure
> out what went wrong.
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

ce30c4fe1a22 ath10k: replace warning with an error message if HTT op version is unset

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9195581/

