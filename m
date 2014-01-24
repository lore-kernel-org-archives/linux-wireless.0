Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:62773 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaAXXgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 18:36:10 -0500
Received: by mail-lb0-f178.google.com with SMTP id u14so2974082lbd.23
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 15:36:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385395140.4443.28.camel@jlt4.sipsolutions.net>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-4-git-send-email-mcgrof@do-not-panic.com>
 <1384377738.28806.15.camel@jlt4.sipsolutions.net> <20131114141105.GB19070@garbanzo.do-not-panic.com>
 <1384440286.13941.27.camel@jlt4.sipsolutions.net> <20131114151809.GB29954@garbanzo.do-not-panic.com>
 <1385395140.4443.28.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 24 Jan 2014 15:35:48 -0800
Message-ID: <CAB=NE6XOk+KYW7OyKpYvnDsxTtj7YcT1p=w49mC4tJuA5bAWcg@mail.gmail.com> (sfid-20140125_003615_077488_4E59569F)
Subject: Re: [RFC 3/5] cfg80211: add regulatory quiescing support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Jouni Malinen <j@w1.fi>, sunitb <sunitb@qca.qualcomm.com>,
	rsunki <rsunki@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 25, 2013 at 7:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> At least we should then also have that patch that QCA has somewhere
> about reporting to userspace that AP was stopped :P

I don't have time to resubmit these, so someone else can pick them up,
I'm happy to review though.

  Luis
