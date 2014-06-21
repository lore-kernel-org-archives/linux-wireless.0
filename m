Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:39814 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaFUPzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 11:55:45 -0400
Received: by mail-ob0-f178.google.com with SMTP id wn1so2386985obc.23
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jun 2014 08:55:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1403345479-13467-3-git-send-email-arend@broadcom.com>
References: <1403345479-13467-1-git-send-email-arend@broadcom.com>
	<1403345479-13467-3-git-send-email-arend@broadcom.com>
Date: Sat, 21 Jun 2014 17:55:44 +0200
Message-ID: <CACna6rz81wbFET4GJH8xQ8aTqGfGccPGmD5vwfmmw9KWsZRPWg@mail.gmail.com> (sfid-20140621_175549_798208_DE54AE16)
Subject: Re: [PATCH 2/8] brcmfmac: Add USB device 43566 to supported devices.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 June 2014 12:11, Arend van Spriel <arend@broadcom.com> wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
>
> Add the USB 43566 device to the supported devices list. The 43566
> is a WiFi-only variant of the 43569. It uses the same FW as 43569.

What about USB ID of this device? You didn't add any. Is it shared
with some different one? A 0a5c:bd27 maybe?
