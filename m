Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34484 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbbHUJxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 05:53:10 -0400
Received: by iodb91 with SMTP id b91so75669811iod.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2015 02:53:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D6F0DB.5050505@msgid.tls.msk.ru>
References: <55D6F0DB.5050505@msgid.tls.msk.ru>
Date: Fri, 21 Aug 2015 11:53:09 +0200
Message-ID: <CACna6rxtaq8LOeY3+c3ThBgjNya6f2Kqm8At9_DKVZHYYRg0iA@mail.gmail.com> (sfid-20150821_115314_528884_67C541D5)
Subject: Re: linux-only "freshness" auth problem??
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 August 2015 at 11:35, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Any hints please? :)

Disable NetworkManager (or make it ignore WiFi interface) and
temporary use wpa_supplicant. Get a log with debugging enables when it
fails and when it success. Look for errors in fail log, compare it
with success one.

-- 
Rafał
