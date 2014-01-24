Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaAXXhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 18:37:16 -0500
Message-ID: <1390606622.25802.0.camel@jlt4.sipsolutions.net> (sfid-20140125_003721_491679_D7355A09)
Subject: Re: [RFC 3/5] cfg80211: add regulatory quiescing support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Jouni Malinen <j@w1.fi>, sunitb <sunitb@qca.qualcomm.com>,
	rsunki <rsunki@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 25 Jan 2014 00:37:02 +0100
In-Reply-To: <CAB=NE6XOk+KYW7OyKpYvnDsxTtj7YcT1p=w49mC4tJuA5bAWcg@mail.gmail.com> (sfid-20140125_003610_311410_0BC460F7)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384366379-25301-4-git-send-email-mcgrof@do-not-panic.com>
	 <1384377738.28806.15.camel@jlt4.sipsolutions.net>
	 <20131114141105.GB19070@garbanzo.do-not-panic.com>
	 <1384440286.13941.27.camel@jlt4.sipsolutions.net>
	 <20131114151809.GB29954@garbanzo.do-not-panic.com>
	 <1385395140.4443.28.camel@jlt4.sipsolutions.net>
	 <CAB=NE6XOk+KYW7OyKpYvnDsxTtj7YcT1p=w49mC4tJuA5bAWcg@mail.gmail.com>
	 (sfid-20140125_003610_311410_0BC460F7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-24 at 15:35 -0800, Luis R. Rodriguez wrote:
> On Mon, Nov 25, 2013 at 7:59 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > At least we should then also have that patch that QCA has somewhere
> > about reporting to userspace that AP was stopped :P

FWIW, I did the above today.

johannes

