Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:33641 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbcDCMGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2016 08:06:13 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: David Lin <dlin@marvell.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
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
Date: Sun, 03 Apr 2016 14:05:56 +0200
In-Reply-To: <f8a657d8b0f3417284f65fbe81bcbf29@SC-EXCH02.marvell.com> (David
	Lin's message of "Thu, 17 Mar 2016 02:10:43 +0000")
Message-ID: <87lh4uc2xn.fsf@nemi.mork.no> (sfid-20160403_140616_756243_A74EDE04)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Lin <dlin@marvell.com> writes:

> We felt some resistance from various people, and get discouraged.

Sorry to hear that.  I believe this is a misunderstanding.  I am
convinced that *everyone* who commented on the driver did so with the
intention to help getting it merged.

I for one would very much like to see this driver in mainline.  But for
that to happen, you wil have to:
 1) create a feature frozen branch for mainline submission
 2) respond relatively quickly to comments received, posting new
    versions of the patch set if necessary

The main issue preventing this driver from being merged so far, in my
view, is that you have continued to add features between each attemt to
get it merged.  Adding new features is of course not bad, but you should
do that in another branch *until* the initial version is accepted.

Let me know if there is anything I can do to help getting this into mainline

Bjørn
