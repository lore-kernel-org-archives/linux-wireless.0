Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23554 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbYLVP5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 10:57:43 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 07:57:43 -0800
Date: Mon, 22 Dec 2008 07:57:37 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 00/16] ath9k: first series for regulatory cleanup
Message-ID: <20081222155737.GF11083@tesla> (sfid-20081222_165746_830300_B55B22BB)
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com> <43e72e890812201110s626d98d9xb82b957c5530c955@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <43e72e890812201110s626d98d9xb82b957c5530c955@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 20, 2008 at 11:10:19AM -0800, Luis Rodriguez wrote:
> On Fri, Dec 19, 2008 at 9:55 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> 
> > This should not have any major functional changes, its mostly
> > cleanup stuff. I've tested HT20 on 2 GHz, will test 5 GHz tomorrow
> > with the HT20/HT40 configurations but I figured I'll get this out
> > today. If someone beats me to testing 5 GHz HT20/HT40 configs me
> > please let me know.
> 
> OK I've tested 5 GHz 802.11a, and 11NAHT40MINUS and found no
> regressions. My AP didn't like to set itself to 11NAHT40PLUS but I
> think that should be OK.

John,

I'll resubmit with the few changes pointed out by Tomas/Johannes and Jouni.

  Luis
