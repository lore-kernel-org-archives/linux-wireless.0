Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:55111 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCKU0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 16:26:08 -0400
From: "W. van den Akker" <listsrv@wilsoft.nl>
To: ath9k-devel@lists.ath9k.org
Subject: Re: [ath9k-devel] [PATCH 0/4] ath9k: Fix usage on SMP systems with PCI devices
Date: Wed, 11 Mar 2009 21:25:58 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
References: <1236650824-9568-1-git-send-email-lrodriguez@atheros.com> <678e6036a51d4d15838f21b4561ec67b.squirrel@www.wilsoft.nl>
In-Reply-To: <678e6036a51d4d15838f21b4561ec67b.squirrel@www.wilsoft.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903112125.58767.listsrv@wilsoft.nl> (sfid-20090311_212612_368175_6DB90045)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 10 March 2009 07:45:29 W. van den Akker wrote:
> Thanks Luis,
>
> I will test it on my system.
>
> To be continued...
>
> gr,
> WIllem
>

I tested this one on my system with IPerf. It looks good.
Until now I didnt get a hang anymore.
Used IPerf -P 2|4|8 and all went well..

Tested with the wireless-testing of 10-3 (so not with the inline
functions mentioned earlier by Luis).

Looks like we have a winner :)

gr,
Willem

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

