Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35322 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbbALJ61 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 04:58:27 -0500
Message-ID: <1421056704.1891.18.camel@sipsolutions.net> (sfid-20150112_105832_779322_03F31584)
Subject: Re: [PATCH net-next] Allow to set net namespace for wireless device
 via RTM_LINK
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 12 Jan 2015 10:58:24 +0100
In-Reply-To: <CAMw6YJJjt4W2JFnUunWgXKL+uUf87dn2LnNSWF6-o2VrXpqiHw@mail.gmail.com> (sfid-20150112_105719_498905_EF48834D)
References: <1410467723-2550-1-git-send-email-vadim4j@gmail.com>
	 <1411075535.2034.5.camel@jlt4.sipsolutions.net>
	 <20141014121627.GA5115@angus-think.lan>
	 <1413798437.10246.12.camel@jlt4.sipsolutions.net>
	 <128188DF-5A9B-47A5-8A89-974CF7CF9064@holtmann.org>
	 <1413802344.10246.20.camel@jlt4.sipsolutions.net>
	 <CAMw6YJKLWQmT-fqg1QLDHbCxnpxWyJUSX+wvOB_pFyE=8HfSfQ@mail.gmail.com>
	 <1420449724.1898.1.camel@sipsolutions.net>
	 <CAMw6YJJgPJw7jizR=Qe_2SOK=S0UKrm9AyE7MHUg1-wODEab2g@mail.gmail.com>
	 <1421055751.1891.10.camel@sipsolutions.net>
	 <CAMw6YJJjt4W2JFnUunWgXKL+uUf87dn2LnNSWF6-o2VrXpqiHw@mail.gmail.com>
	 (sfid-20150112_105719_498905_EF48834D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-12 at 11:57 +0200, Vadim Kochan wrote:
> Thank you! Seems reasonably for me.
> 
> The question is not related to the thread:
>      May be this is not very good idea to copy behavior from other
> tools but what do you think about
>      add the same ability to use named network namespaces as it is
> done in iproute2 - from /var/run/netns ?

I have no objection to that of course - I believe it didn't exist back
when I wrote this code, or at least I didn't know about it then :)

johannes

