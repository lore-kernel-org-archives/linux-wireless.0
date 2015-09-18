Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34394 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbbIRV30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 17:29:26 -0400
Received: by iofb144 with SMTP id b144so70319408iof.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 14:29:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
Date: Fri, 18 Sep 2015 23:29:25 +0200
Message-ID: <CACna6rz6P4==K=fVr=Vnn8fkwvFJppEqub6dCEcZ8DyK5Bpa=Q@mail.gmail.com> (sfid-20150918_232929_384221_74A06FF2)
Subject: Re: [PATCH 00/16] brcmfmac: new device support and P2P fixes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 September 2015 at 22:08, Arend van Spriel <arend@broadcom.com> wrote:
> * correct set and get tx-power.

Oh, I got a similar patch, you were faster :)


> The series should be applied to master branch of the wireless-drivers-next
> repository after the series sent earlier with
> Message-ID: <1440620104-2715-1-git-send-email-arend@broadcom.com>
> and patch "brcmfmac: Reset PCIE devices after recognition." with
> Message-ID: <1440684846-17214-1-git-send-email-arend@broadcom.com>.

Applied and tested with SR400ac (2 * BCM43602), no regressions
noticed. Nice work!
