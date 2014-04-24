Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40056 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaDXMEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 08:04:40 -0400
Received: by mail-lb0-f178.google.com with SMTP id s7so1943987lbd.9
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 05:04:38 -0700 (PDT)
Message-ID: <5358FDD6.9070508@cogentembedded.com> (sfid-20140424_140501_635177_E635587E)
Date: Thu, 24 Apr 2014 16:04:38 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Adam Lee <adam.lee@canonical.com>, linux-wireless@vger.kernel.org
CC: netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] Revert "rtlwifi: rtl8188ee: enable MSI interrupts
 mode"
References: <1398308924-15312-1-git-send-email-adam.lee@canonical.com>
In-Reply-To: <1398308924-15312-1-git-send-email-adam.lee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 24-04-2014 7:08, Adam Lee wrote:

> This reverts commit 2a54eb5e1476426ee639bbfbe179b52342a0d82c.

> 94010fa0dd07e8b904e7c6b6589f15573008ab15 introduced MSI interrupts mode

    Please also specify that commit's summary line in parens.

> support, which seemed safe enough with RTL8188EE and RTL8723BE as
> RealTek's testing results, but some users reported their RTL8188EE
> modules could not connect to any wireless network after the MSI mode was
> enabled by Ubuntu 14.04.

> So, let's fallback to pin-based mode until rtlwifi's MSI support get
> good compatibility.

> BugLink: https://bugs.launchpad.net/bugs/1310512
> Signed-off-by: Adam Lee <adam.lee@canonical.com>

WBR, Sergei


