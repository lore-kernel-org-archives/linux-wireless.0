Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:36928 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaJGGjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 02:39:35 -0400
Received: by mail-la0-f47.google.com with SMTP id pv20so5643489lab.6
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2014 23:39:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj985Di47A3OUSKn3ycW01Ohmeqs=uL4y_59YL+HyUDWvO0g@mail.gmail.com>
References: <1412251000-25377-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAEFj985Di47A3OUSKn3ycW01Ohmeqs=uL4y_59YL+HyUDWvO0g@mail.gmail.com>
Date: Tue, 7 Oct 2014 08:39:33 +0200
Message-ID: <CALhHN=pFM8-Ck62nzNfOkS+bU3Xm_k30_AYrqagP0tY9nuV4pw@mail.gmail.com> (sfid-20141007_083940_256346_B80E9B47)
Subject: Re: [PATCH] ath10k: don't create bssid peer for ibss
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 October 2014 03:06, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> On Thu, Oct 2, 2014 at 7:56 PM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>> It's not really necessary to create bssid peer for
>> bssid. Self-address peer is sufficient.
>>
>> This prevents some firmware revisions from crashing.
>>
>
> Which firmware? AFAIK, only firmware version 636 supports adhoc, right?
>
Yes, this is for 636.

BR
Janusz
