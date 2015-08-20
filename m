Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35574 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbbHTVUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 17:20:24 -0400
Received: by iodt126 with SMTP id t126so61454474iod.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2015 14:20:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440101168-2252-1-git-send-email-arend@broadcom.com>
References: <1440101168-2252-1-git-send-email-arend@broadcom.com>
Date: Thu, 20 Aug 2015 23:20:23 +0200
Message-ID: <CACna6rxtHaj-czX6z28UL8LL5VAyxVrEgimn5fVz8NpU5DOwgw@mail.gmail.com> (sfid-20150820_232027_166491_7ADA0632)
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

Tested-by: Rafał Miłecki <zajec5@gmail.com>

No regression with this version, getting platform NVRAM works.
