Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:59442 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3IZGEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 02:04:41 -0400
Received: by mail-bk0-f53.google.com with SMTP id d7so222935bkh.40
        for <linux-wireless@vger.kernel.org>; Wed, 25 Sep 2013 23:04:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878uykunyc.fsf@kamboji.qca.qualcomm.com>
References: <20130925210455.2596.36889.stgit@localhost6.localdomain6>
	<20130925210848.2596.56332.stgit@localhost6.localdomain6>
	<CA+BoTQ=BhtjC1YNLs9OYBPN6TiYhyrwYoK2A1wifS01HVJp1YA@mail.gmail.com>
	<878uykunyc.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 26 Sep 2013 08:04:39 +0200
Message-ID: <CA+BoTQ=v0snRLTP44LXVdQx2UVKYxLCW-JiWyMWOR4eEzMvFKA@mail.gmail.com> (sfid-20130926_080459_616724_0C5A2347)
Subject: Re: [PATCH 3/3] ath10k: implement firmware IE container support
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 September 2013 07:55, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Did you skip board file intentionally?
>
> Yes, because my understanding is that the board file is not tied to any
> particular firmware version. The board file should be specific to the
> hardware configuration in use, or at least that's how it is with ath6kl.

But the board file is not loaded at all for API 2. The api_1 variant
requests 3 files and can result with up to 3 binaries loaded. api_n
requests 1 file and can result with up to 2 binaries loaded.


Michał.
