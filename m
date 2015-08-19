Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37395 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbbHSXG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 19:06:27 -0400
Received: by igui7 with SMTP id i7so18058873igu.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 16:06:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55CB0ACA.3000109@broadcom.com>
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>
	<CACna6rwJwjiNKnfjV8cH9_fvE38SWLf5ng8ap15OktUZQhOedg@mail.gmail.com>
	<55AD2C8F.9010509@broadcom.com>
	<CACna6rzdE1GubDquszC3jqJjf_UbfPVNrt=oNKSrqj=t9HPBHg@mail.gmail.com>
	<55CB0ACA.3000109@broadcom.com>
Date: Thu, 20 Aug 2015 01:06:27 +0200
Message-ID: <CACna6ryZ6qJY7t12CQjyD1kvkXa5kpQp3J+eyEq4Gn0DVR9TMA@mail.gmail.com> (sfid-20150820_010630_925218_3D03892B)
Subject: Re: [PATCH 0/7] brcmfmac: nvram loading and code rework
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hante Meuleman <meuleman@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 August 2015 at 10:58, Arend van Spriel <arend@broadcom.com> wrote:
> You did a warm reboot of the device, right? There seems to be an issue
> because on OpenWrt the brcmfmac is not unloaded upon warm reboot, which
> makes the device unaccessible. Because on OpenWrt the firmware request is
> synchronous (OpenWrt patch on top of upstream brcmfmac) it results in probe
> failing on invalid access making the issue OpenWrt specific. Hante created a
> fix for the warm reboot issue.

Hante could you share your fix?
