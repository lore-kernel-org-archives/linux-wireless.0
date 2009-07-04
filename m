Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:58095 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbZGDVYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 17:24:25 -0400
Received: by bwz25 with SMTP id 25so42648bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jul 2009 14:24:27 -0700 (PDT)
Message-ID: <4A4FC889.9000401@gmail.com>
Date: Sat, 04 Jul 2009 23:24:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linville@tuxdriver.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/5] ath5k: do not release irq across suspend/resume
References: <1246726795-3934-1-git-send-email-me@bobcopeland.com> <1246726795-3934-5-git-send-email-me@bobcopeland.com>
In-Reply-To: <1246726795-3934-5-git-send-email-me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2009 06:59 PM, Bob Copeland wrote:
> Paraphrasing Rafael J. Wysocki: "drivers should not release PCI IRQs
> in suspend."  Doing so causes a warning during suspend/resume on some
> platforms.

Hmm, I added it because I was told an irq can change over suspend (or at
least it could in the past). I think it's not true anymore, since we
would have serious problems with the code all over the tree.

I can't find where Rafael uttered those words above, do you have a link?

> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Thanks.
