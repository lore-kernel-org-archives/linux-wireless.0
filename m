Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60499 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1HWV7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 17:59:52 -0400
Received: by vxi9 with SMTP id 9so503335vxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 14:59:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wre5oogs.fsf@purkki.adurom.net>
References: <4E4C6258.1030409@openwrt.org>
	<1313766622-15092-1-git-send-email-bjordan@rajant.com>
	<87wre5oogs.fsf@purkki.adurom.net>
Date: Tue, 23 Aug 2011 17:59:51 -0400
Message-ID: <CAFKp-_cabGjejG1Mbzcof5jikyOcfYs=4SBLoP3LG=9xALERhw@mail.gmail.com> (sfid-20110823_235955_899520_A5C8D2A4)
Subject: Re: [PATCH] ath9k: fix MGMT packets when using TKIP
From: Bill Jordan <bjordan@rajant.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 22, 2011 at 4:11 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Bill Jordan <bjordan@rajant.com> writes:
>
>> Prevent 8 bytes from being truncated from MGMT packets
>> when using TKIP.
>
> A bit more information in the commit log would be nice. Is this is a
> regression or an old bug? Maybe a stable candidate?

I believe it is an old bug.

Bill Jordan
