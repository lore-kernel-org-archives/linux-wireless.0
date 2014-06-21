Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:61520 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaFUP6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 11:58:17 -0400
Received: by mail-oa0-f41.google.com with SMTP id l6so8630740oag.14
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jun 2014 08:58:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1403345479-13467-1-git-send-email-arend@broadcom.com>
References: <1403345479-13467-1-git-send-email-arend@broadcom.com>
Date: Sat, 21 Jun 2014 17:58:16 +0200
Message-ID: <CACna6ryu6b=d9hpi71czo1q6uiWDZ4u+hXO-omAg6g23Y68xug@mail.gmail.com> (sfid-20140621_175828_573657_5BB3B146)
Subject: Re: [PATCH 0/8] brcmfmac: new USB devices, vendor command, and cleanup
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 June 2014 12:11, Arend van Spriel <arend@broadcom.com> wrote:
> The patch series add driver support for new USB device. These are 11ac fullmac
> devices with USB3.0 interface. Also opting for the vendor-specific netlink
> command instead of cfg80211 testmode. The remaining patches are small cleanup
> patches.
>
> This series is intended for 3.17 and applies to the master branch of the
> wireless-next repository.

I've slightly updated
http://wireless.kernel.org/en/users/Drivers/brcm80211
, feel free to correct me if I did anything wrong.
