Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45193 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbbARSkT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 13:40:19 -0500
MIME-Version: 1.0
In-Reply-To: <54BBF207.2030708@broadcom.com>
References: <CA+55aFyr9LC7oLoJeyFwK4KRURbbUyO63jznTTAkQF+9LBAsfg@mail.gmail.com>
	<CANUX_P0LCr3fzqLyjKQbZ-P2hAV-Nk6=AMm=oFOWCLW34cRg2w@mail.gmail.com>
	<CA+55aFzEr-R1anNm91pnM=ujfhBstJikZBVtduphff1PtccHDw@mail.gmail.com>
	<54BBF207.2030708@broadcom.com>
Date: Mon, 19 Jan 2015 06:40:18 +1200
Message-ID: <CA+55aFws=-MY+rUsEny=DsBx9gct93BnfeGXSnOCLxEFtvDj8A@mail.gmail.com> (sfid-20150118_194025_259484_6F71A880)
Subject: Re: Wireless scanning while turning off the radio problem..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 19, 2015 at 5:48 AM, Arend van Spriel <arend@broadcom.com> wrote:
>
> So as you indicated you were in location where none of your configured
> networks were available. Flipping the rfkill switch in that situation is the
> way to trigger the issue.

So you certainly seem to be able to explain the behavior I saw under
the circumstances they happened.

I suspect the best thing to do is to just apply your patch. I may not
be able to really test it much for the next few days anyway. Emmanuel?

             Linus
