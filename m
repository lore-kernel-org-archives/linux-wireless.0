Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57330 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbcGHNrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 09:47:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: Fix endianness for event TLV type
 TLV_BTCOEX_WL_SCANTIME
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1467275483-24091-1-git-send-email-prasunmaiti87@gmail.com>
To: Prasun Maiti <prasunmaiti87@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Message-Id: <20160708134703.E88D061154@smtp.codeaurora.org> (sfid-20160708_154709_221141_44CFDB23)
Date: Fri,  8 Jul 2016 13:47:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prasun Maiti <prasunmaiti87@gmail.com> wrote:
> The two members min_scan_time and max_scan_time of structure
> "mwifiex_ie_types_btcoex_scan_time" are of two bytes each. The values
> are assigned directtly from firmware without endian conversion handling.
> So, wrong datas will get saved in big-endian systems.
> 
> This patch converts the values into cpu's byte order before assigning them
> into the local members.
> 
> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

c18b104dd249 mwifiex: Fix endianness for event TLV type TLV_BTCOEX_WL_SCANTIME

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9206939/

