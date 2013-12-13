Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:42663 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3LMJCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 04:02:52 -0500
Message-ID: <52AACD38.5060203@broadcom.com> (sfid-20131213_100257_055246_35D5AAE0)
Date: Fri, 13 Dec 2013 10:02:48 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: Re: [PATCH 00/18] brcmfmac: sdio rework and msgbuf protocol changes
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2013 11:58 AM, Arend van Spriel wrote:
> This series consists mostly of cleanup in SDIO driver code. Other changes
> are preparing to new firmware protocol called msgbuf, which is intended
> for PCIe fullmac devices.

Probably needless to say, but saying it anyway ;-). This patch series is 
intended fro 3.14. It applies to the master branch of the wireless-next 
repository.

Regards,
Arend
