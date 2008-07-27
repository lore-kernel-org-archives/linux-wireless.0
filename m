Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:58740 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062AbYG0Gla (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 02:41:30 -0400
Message-ID: <1617.92.50.126.45.1217140888.squirrel@webmail.madwifi.org> (sfid-20080727_084143_586634_C75E3674)
In-Reply-To: <43e72e890807260744j5473d723qba9d30f29e87abee@mail.gmail.com>
References: <43e72e890807260744j5473d723qba9d30f29e87abee@mail.gmail.com>
Date: Sun, 27 Jul 2008 08:41:28 +0200 (CEST)
Subject: Re: Reporting the right Linux wireless bug
From: "Michael Renzmann" <mrenzmann@madwifi.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Dan Williams" <dcbw@redhat.com>, "Jouni Malinen" <j@w1.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis.

Luis R. Rodriguez wrote:
> To help users report bugs correctly I've set up this page:
> http://wireless.kernel.org/en/users/Reporting_bugs
>
> Please help review/edit/expand accordingly.

I understand that the page is not yet complete, but still I'd like to note
two things I came across on a first quick glance:

Section "Wireless Components":
"... which let users use to use wireless. ..." doesn't sound correct. How
about "... which let users use wireless devices. ..."?

Section "Kernel Panics":
It states that kernel panics should be reported immediately, but it does
not explain where or how to report them. The following text then just
explains how to identify the component that causes "other bugs" and where
to report them.

Bye, Mike
