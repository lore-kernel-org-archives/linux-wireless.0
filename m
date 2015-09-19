Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:18783 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbISJk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 05:40:26 -0400
Message-ID: <55FD2D87.2050909@broadcom.com> (sfid-20150919_114039_909957_CBE9BB36)
Date: Sat, 19 Sep 2015 11:40:23 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/16] brcmfmac: new device support and P2P fixes
References: <1442606899-31872-1-git-send-email-arend@broadcom.com> <CACna6rz6P4==K=fVr=Vnn8fkwvFJppEqub6dCEcZ8DyK5Bpa=Q@mail.gmail.com>
In-Reply-To: <CACna6rz6P4==K=fVr=Vnn8fkwvFJppEqub6dCEcZ8DyK5Bpa=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2015 11:29 PM, Rafał Miłecki wrote:
> On 18 September 2015 at 22:08, Arend van Spriel <arend@broadcom.com> wrote:
>> * correct set and get tx-power.
>
> Oh, I got a similar patch, you were faster :)

Hope our patch works for you.

>> The series should be applied to master branch of the wireless-drivers-next
>> repository after the series sent earlier with
>> Message-ID: <1440620104-2715-1-git-send-email-arend@broadcom.com>
>> and patch "brcmfmac: Reset PCIE devices after recognition." with
>> Message-ID: <1440684846-17214-1-git-send-email-arend@broadcom.com>.
>
> Applied and tested with SR400ac (2 * BCM43602), no regressions
> noticed. Nice work!

Thanks for testing.

Regards,
Arend
