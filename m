Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61063 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2FKNTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 09:19:23 -0400
Message-ID: <4FD5F044.2000307@qca.qualcomm.com> (sfid-20120611_151926_727828_74E4AF4A)
Date: Mon, 11 Jun 2012 16:19:00 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Naveen Singh <navesing@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [patch v4] ath6kl: Different version for different FW binaries
References: <1339055042-27696-1-git-send-email-navesing@qca.qualcomm.com>
In-Reply-To: <1339055042-27696-1-git-send-email-navesing@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2012 10:44 AM, Naveen Singh wrote:
> Need to have different FW versioning for different FW binaries.
> This is handled by appending different meta data in firmware
> binaries.
> 
> Signed-off-by: Naveen Singh <navesing@qca.qualcomm.com>

Thanks, applied with minor changes:

commit b5b6f6a9a07ac230d54a85a9fb9e691c85f2eb0a
Author: Naveen Singh <navesing@qca.qualcomm.com>
Date:   Thu Jun 7 00:44:02 2012 -0700

    ath6kl: use firmware version from FW IE

    Need to have different FW versioning for different FW binaries.
    This is handled by appending different meta data in firmware
    binaries.

    kvalo: add an empty line before a debug message, use '0' instead of
'0x00',
    fix indentation

    Signed-off-by: Naveen Singh <navesing@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle
