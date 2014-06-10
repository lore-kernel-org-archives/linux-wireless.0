Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:62235 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaFJV6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 17:58:39 -0400
Received: by mail-la0-f51.google.com with SMTP id gf5so4388859lab.10
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 14:58:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANy8jx+RY-_wbX5JqdF_xwyP+2XQ-V9Ae95Y5MOzd=fyir8KTw@mail.gmail.com>
References: <CANy8jx+RY-_wbX5JqdF_xwyP+2XQ-V9Ae95Y5MOzd=fyir8KTw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 10 Jun 2014 14:58:18 -0700
Message-ID: <CAB=NE6Uq6NCne+nH6gMWWgbZT6H+Ka5Mz8aqGiq2UKzMmogU2g@mail.gmail.com> (sfid-20140610_235844_686220_00E317FF)
Subject: Re: max_erip/tx_power not being set correctly
To: John Walker <john@x109.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 24, 2014 at 5:34 AM, John Walker <john@x109.net> wrote:
> I hope you can help.A bug seems to have been introduced in 3.10.34ish
> (3.10.32 is ok) linux kernel where a statically compiled regulator
> db.txt file does not set max_erip /tx_power correctly.

If using stock vanilla kernel and you noticed an issue between a
stable release, ie between 3.10.32 and 3.10.34 you should be able to
bisect. Furthermore the description of the issue you are running into
is vague. You will need to provide a bit more details with regards to
what exactly was seen before and what is new you see after. The iw
list output from both would be useful as well as the kernel logs.

  Luis
