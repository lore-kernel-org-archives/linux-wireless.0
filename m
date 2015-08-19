Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36598 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbbHSVtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 17:49:13 -0400
Received: by iodv127 with SMTP id v127so25238844iod.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 14:49:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439708139-7527-3-git-send-email-arend@broadcom.com>
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>
	<1439708139-7527-3-git-send-email-arend@broadcom.com>
Date: Wed, 19 Aug 2015 23:49:13 +0200
Message-ID: <CACna6ryYkWOufztYgA6dhYkUUrLPC+05m2UX1J89uS8eha=YYQ@mail.gmail.com> (sfid-20150819_234916_898043_659DC6FE)
Subject: Re: [PATCH V2 2/7] brcmfmac: correct interface combination info
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 August 2015 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
> The interface combination provided by brcmfmac did not truly reflect
> the combinations supported by driver and/or firmware.

This is OK in general but may conflict a bit with my recent:
brcmfmac: set wiphy's addresses to provide valid MACs

My implementation was designed for a one combo only, I'll submit a fix for that.
