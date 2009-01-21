Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:41054 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbZAUEQC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 23:16:02 -0500
Received: by rv-out-0506.google.com with SMTP id k40so3438804rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 20:16:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090120200802.GF19581@tesla>
References: <9664a4720901201133g5671c7f0x718c4bd187b1d901@mail.gmail.com>
	 <20090120200802.GF19581@tesla>
Date: Tue, 20 Jan 2009 23:16:01 -0500
Message-ID: <9664a4720901202016o3776205fk2a8bec6bb1331c90@mail.gmail.com> (sfid-20090121_051613_934028_7A95D3BA)
Subject: Re: Atheros (madwifi/ath5k) virtual STA support
From: Catalin Patulea <cat@vv.carleton.ca>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 3:08 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Please use linux-wireless only for upstream drivers like ath5k or ath9k.
Apologies for that, I will direct my madwifi questions to the
project's mailing list.

I had actually meant my question in a driver-agnostic sense as well
("Are there any hardware limitations blocking virtual STA support?"),
and hoped I could harvest the brains of the knowledgeable people on
linux-wireless regardless of project affiliation. ;-) Regardless, I
got my answer.

> You will most likely see this first implemented in ath9k. Work is underway
> for just that.
Who's working on this? Any time estimates (not making demands, just
asking)? Also, I was under the impression that ath9k is only meant for
802.11n chipsets (as opposed to abg), and therefore that AR5414 would
not be supported. What am I missing?

In truth, I should stop sending mails and just try it on my device. I
haven't. If there's no more information on the topic, I'm open to the
good old "try it and tell us if it works" ;-).

> http://wireless.kernel.org/en/developers/Documentation/specs#Atherosspecifications
Thanks!

Catalin
