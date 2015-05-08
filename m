Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:36844 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbbEHKYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 06:24:05 -0400
Received: by iecnq11 with SMTP id nq11so60115581iec.3
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2015 03:24:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <554C8B34.3070206@broadcom.com>
References: <1431025661-8879-1-git-send-email-zajec5@gmail.com>
	<554C8B34.3070206@broadcom.com>
Date: Fri, 8 May 2015 12:24:04 +0200
Message-ID: <CACna6ryvJV7DaU+Y-jYS9Z3rE6Zh9dwKMb8-xEb-+s476rsp7w@mail.gmail.com> (sfid-20150508_122410_435976_B33137DE)
Subject: Re: [PATCH 1/2] brcmfmac: move strings debugging Broadcom errors to debug.c
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 May 2015 at 12:08, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/07/15 21:07, Rafał Miłecki wrote:
>>
>> They are used with CONFIG_BRCMDBG so it makes sense to put them in debug
>> specific file. Also they aren't really specific to fwil.c.
>
> Actually they are. fwil is abbreviation of firmware interface layer and the
> intention is to give the error as given by firmware. However, as you
> discovered it also (wrongly) maps linux errors and that needs to be fixed as
> it can confuse people staring at the log.

OK, my commit message is wrong. What about change itself? Should I
just fix the commit message?
