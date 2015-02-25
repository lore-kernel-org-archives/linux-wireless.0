Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:45191 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbbBYSc0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 13:32:26 -0500
Message-ID: <20150225182543.20582.qmail@stuge.se> (sfid-20150225_193229_831369_6608C151)
Date: Wed, 25 Feb 2015 19:25:43 +0100
From: Peter Stuge <peter@stuge.se>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jouni Malinen <j@w1.fi>, Andrew McGregor <andrewmcgr@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Thomas =?utf-8?B?SMO8aG4=?= <thomas@net.t-labs.tu-berlin.de>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
References: <20150223224305.GA30228@w1.fi> <21739.50662.902775.901924@gargle.gargle.HOWL> <CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com> <CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com> <20150224102611.GA30806@w1.fi> <80AA1103-EBCD-4C18-A950-B03FF516E5AC@net.t-labs.tu-berlin.de> <20150224181454.GA30859@w1.fi> <54ED56D8.9030806@openwrt.org> <20150225144723.GA6903@w1.fi> <CA+55aFyvhgFMRAg2ftuN_cykGs_3-Oyabhi_N6S-J1daVFFRzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFyvhgFMRAg2ftuN_cykGs_3-Oyabhi_N6S-J1daVFFRzw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linus Torvalds wrote:
> Last time I had connection issues with this laptop, nothing ended up
> happening in the end, and I had people pipe up saying they had had
> similar problems. I'd hate for the same "nothing" to happen this time
> just because people aren't 100% sure what the final right thing is to
> do. So I'd really like people to apply the simple workarounds for now
> because clearly something is badly wrong, and *if* there is some
> better resolution later, that's fine.
..
> So I'm sure I can improve reception of my laptop, but that's not the
> point. The point is that bad wireless networks aren't so unusual, and
> right now things clearly don't work as well as they could.

Those two patches (the one-liner in particular) should have gone
in already 5-10 years ago. This has been an embarrassing problem
for many years.

I'm glad that people jumped this time around.


//Peter
