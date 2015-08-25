Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:32980 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbbHYQJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 12:09:05 -0400
Received: by iods203 with SMTP id s203so192375107iod.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2015 09:09:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440101168-2252-1-git-send-email-arend@broadcom.com>
References: <1440101168-2252-1-git-send-email-arend@broadcom.com>
Date: Tue, 25 Aug 2015 18:09:04 +0200
Message-ID: <CACna6ryBL+bpBM4TekcNCotou-gey=k6_aYJVT+F-Sm0V0fuiw@mail.gmail.com> (sfid-20150825_180911_846168_DC6B76F7)
Subject: Re: [PATCH V3 0/6] brcmfmac: nvram loading and code rework
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 August 2015 at 22:06, Arend van Spriel <arend@broadcom.com> wrote:
> This series comprises of following changes:
> - support NVRAM loading for bcm47xx platform.
> - revise announced interface combinations and validate against it.
> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
> - PCIe fix for handling queue overflow.
> - support more firmware events (for bcm4339 firmware).
>
> The series is intended for v4.3 kernel and applies to the master branch
> of the wireless-drivers-next repository. Removed patch from this series
> that reportedly has issue on OpenWrt platform.

I believe that V3 also got following patch dropped:
brcmfmac: consolidate ifp lookup in driver core
https://patchwork.kernel.org/patch/6767991/

As we tracked regressing patch to be "brcmfmac: Increase nr of
supported flowrings.", I believe you can safely re-submit above (ifp
lookup) one. I tested it on top of wireless-drivers-next brcmfmac and
it works fine (no regressions).

Thanks for your work!
