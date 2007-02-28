Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:36834 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153AbXB1RVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 12:21:41 -0500
Received: by nf-out-0910.google.com with SMTP id o25so618947nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 09:21:38 -0800 (PST)
Message-ID: <c4db5c50702280921i6f0689adm197b5fcb19f1852f@mail.gmail.com>
Date: Wed, 28 Feb 2007 17:21:38 +0000
From: "Robin Cornelius" <robin.cornelius@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/28] rt2x00: Add debugfs support
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702281809.15486.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200702281507.13953.IvDoorn@gmail.com>
	 <200702281752.36875.IvDoorn@gmail.com>
	 <1172681674.5015.43.camel@johannes.berg>
	 <200702281809.15486.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/28/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Wednesday 28 February 2007 17:54, Johannes Berg wrote:
> > On Wed, 2007-02-28 at 17:52 +0100, Ivo van Doorn wrote:
> >
> > > But there is some progress I believe, Robin seems to have managed to
> > > compile cfg80211 now against a 2.6.20 kernel.
> >
> > Guys, why do we know nothing about this? Could you *please* come out of
> > your hole?
>
> Perhaps because Robin told it to me 5 minutes before I send that mail? ;)
> He is still struggling a bit with the Makefile, but at least some progress has been made.
>
> I have added Robin to the CC list, so he can explain the current status himself. :)

Hi guys,

Ok status is as follows.

d80211 and cfg80211 will compile against a 2.6.20 kernel (i believe
2.6.18 or better will do).

I have achieved this starting with the d80211 and cfg80211 code from
wireless-dev.git, and applying some of the intel patches from the
d80211 subsystem package and a couple of other pointer cast fixes. I
have not made a patch set yet as I am still experimenting.

The problem i am up against is now i must disable the existing
wireless extensions in the kernel and this can only be done with a
kernel rebuild. I have not tried this yet as I am not sure there is a
lot of point continuing on this route as its not possible to
completely out of kernel build the cfg80211 modules, which was the
target for my experimentation.



-- 
Robin Cornelius
http://www.byteme.org.uk
