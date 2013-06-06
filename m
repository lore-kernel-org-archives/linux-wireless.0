Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:61097 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3FFDxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 23:53:08 -0400
MIME-Version: 1.0
In-Reply-To: <51B006AE.6080309@candelatech.com>
References: <1370488216-11626-1-git-send-email-sujith@msujith.org>
	<51B006AE.6080309@candelatech.com>
Date: Thu, 6 Jun 2013 12:53:07 +0900
Message-ID: <CA+55aFyvWJWfXHZ2hSWcsmBTnk5s2CNbTGQYNmVoywXLuwHrxQ@mail.gmail.com> (sfid-20130606_055312_776497_686CF060)
Subject: Re: [PATCH] ath9k: Use minstrel rate control by default
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 6, 2013 at 12:49 PM, Ben Greear <greearb@candelatech.com> wrote:
>
> Last I tested there were still advantages to ath9k rate control in our
> environment,
> (including when running through an attenuator and over-the-air),
> so I think it should be left in to keep minstrel honest if nothing else.

I don't care if it is left in, but it had better not be enabled by
default.  Randomly not being able to connect AT ALL to wireless
networks is not a valid "rate control" model.

                 Linus
