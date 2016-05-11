Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59260 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbcEKTqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 15:46:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,7/7] wil6210: add support for device led configuration
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1461589078-29854-8-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	Maya Erez <qca_merez@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Message-ID: <42b47b29b209461e82c50c2b2ffff5a1@euamsexm01a.eu.qualcomm.com> (sfid-20160511_214631_632201_F061EE20)
Date: Wed, 11 May 2016 21:46:12 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> Add the ability to configure the device led to be used for notifying
> the AP activity (60G device supports leds 0-2).
> The host can also configure the blinking frequency of the led in
> three states.
> 
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

Thanks, 1 patch applied to ath.git:

10d599ad84a1 wil6210: add support for device led configuration

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8927801/

