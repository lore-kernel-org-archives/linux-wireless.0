Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46700 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab0E1TLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 15:11:31 -0400
Received: by pvg11 with SMTP id 11so539634pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 May 2010 12:11:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <93781E992CBA7843962D8B0E7D683F3C1117B01DFD@SC1EXMB-MBCL.global.atheros.com>
References: <93781E992CBA7843962D8B0E7D683F3C1117B01DFD@SC1EXMB-MBCL.global.atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 28 May 2010 12:11:11 -0700
Message-ID: <AANLkTikBTx4sH9OkJKDkxD0SyZrKfdiEUfpEbVphzTNf@mail.gmail.com>
Subject: Re: New procedure for reg dbase
To: Michael Green <Michael.Green@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some notes by Michael about possible procedures. I think this makes
sense. Michael, some comments below, and please keep this thread
public, and please do reply publicly.

  Luis

On Fri, May 28, 2010 at 8:28 AM, Michael Green
<Michael.Green@atheros.com> wrote:
>
> Hi Luis,
>
> I think we can argue that although anyone can send a proposed
> patch for the wireless-regdb, only certain people are qualified to review/accept
> them.  ATHR need not be the only “approver”, but it does need to be
> regulatory experts (not Linux experts) who advise what proposed
> patches should be implemented.  Reason is that although anyone can
> read through a doc from a regulator which seems to state what channels
> are allowed, it takes a qualified regulatory person to understand how that
> doc may or may not fit in with other knowledge and to interpret the
> doc correctly.

Michael, I understand your suggestion but I don't think we can apply
this to wireless-regdb. I think the best we can do is take 'regulatory
expert' opinions more seriously and value their input more than
someone posting some random patch who never has posted anything on
linux-wireless before. So what I mean by this is anyone should be able
to post patches but those who do dedicate their full time job to
regulatory would obviously be able to chime in and help with better
interpretation of local regulatory rules.

> So I propose your community consider a group such as
> “regulatory reviewers”.   Notices or proposed patches can be sent
> to this group. After a  set turnaround time (7 days? 14 days? 30 days?)?
> If there is no further discussion or disagreement over the proposed
> patch, then it is accepted. And during that time, there will likely
> be concensus by the “regulatory reviewers” to recommend the patch
> be rejected, accepted or fixed+accepted.

Right now I think you're our only true 'regulatory expert', not sure
if we'd have any others, so I think the best we can probably do is
just take your those expert's review/suggestions into high
consideration but do not think they should have final say. The final
say must come from consensus from the community. I think generally the
consensus naturally will steer towards listening to the experts but
that is not something you can or should mandate IMHO.

> Then any company can nominate their RF regulatory expert to
> join the “regulatory reviewers”. The actual distribution list can be cc’ed to
> whoever should be included. But the physical group of “regulatory
> reviewers” ought to be considered carefully to ensure it’s the
> regulatory experts who give concensus on each proposed patch.

Not sure if we have enough of those to even consider such a thing. I
think the current model works OK but what we do need is a better
documented process of how long it may take to get a change included,
and who to CC to help review changes. The reviewers must also be
wiling to comment publicly on threads and engage with the specific
patch submitters.

Also what do we do for example if you are on vacation? :)

> And Linville in the end will make final decision (but he will have
> a firm consensus and reference to regulatory documents from the
> reg. reviewers as basis for his final decision.
>
> Any company with an RF regulatory person, is
> welcome to be added to the “reg reviewers” group.  This should only
> include people involved in radio spectrum activities and regulatory
> conformance.

I think this would be great but right now I think we just have you as
a qualified regulatory expert.

> Michael Green
>
> Manager, Global Product Compliance
>
> Atheros Communications, Inc.
>
> 5480 Great America Parkway
> Santa Clara CA 95054
> 781-400-1491 (office)
> 508-380-4921 (cell)
> www.atheros.com

  Luis
