Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38752 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbcDOMkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 08:40:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Bj=C3=B8rn?= Mork <bjorn@mork.no>
Cc: David Lin <dlin@marvell.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	"Pete Hsieh" <peteh@marvell.com>
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
	<CAGRGNgUxNdbBn7HU+==P9uM3ciN-5pWRXDT+oYzCTLoATCR_xg@mail.gmail.com>
	<a5d1b2b861294df2badcfe38c74a13db@SC-EXCH02.marvell.com>
	<CAGRGNgXUVV4GpcSKnG9QLUz1-TQiRoeWLg0MLkYVZOn-QF3U0A@mail.gmail.com>
	<f8a657d8b0f3417284f65fbe81bcbf29@SC-EXCH02.marvell.com>
	<87lh4uc2xn.fsf@nemi.mork.no>
Date: Fri, 15 Apr 2016 15:40:45 +0300
In-Reply-To: <87lh4uc2xn.fsf@nemi.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of "Sun, 03
	Apr 2016 14:05:56 +0200")
Message-ID: <87wpnzoxiq.fsf@kamboji.qca.qualcomm.com> (sfid-20160415_144055_574653_9527BD0D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjørn Mork <bjorn@mork.no> writes:

> David Lin <dlin@marvell.com> writes:
>
>> We felt some resistance from various people, and get discouraged.
>
> Sorry to hear that.  I believe this is a misunderstanding.  I am
> convinced that *everyone* who commented on the driver did so with the
> intention to help getting it merged.

Exactly. Why would we otherwise spend so much time reviewing the driver
if we would not want it included?

> I for one would very much like to see this driver in mainline.  But for
> that to happen, you wil have to:
>  1) create a feature frozen branch for mainline submission
>  2) respond relatively quickly to comments received, posting new
>     versions of the patch set if necessary
>
> The main issue preventing this driver from being merged so far, in my
> view, is that you have continued to add features between each attemt to
> get it merged.  Adding new features is of course not bad, but you should
> do that in another branch *until* the initial version is accepted.

Thanks for the good summary, I think we should even add that to our wiki
as a guideline for new drivers. Then submitting a new driver (or normal
patches for that matter) you really want to optimise the use of
reviewer's time. Just fix the issues pointed out in the review, don't do
anything extra as the chances are that it just slows down everything.

-- 
Kalle Valo
