Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:40506 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYKYV35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 16:29:57 -0500
Received: by yx-out-2324.google.com with SMTP id 8so102297yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 13:29:55 -0800 (PST)
Message-ID: <b6c5339f0811251329h1130fd4aladcbfda52f0542eb@mail.gmail.com> (sfid-20081125_223001_377084_196CB375)
Date: Tue, 25 Nov 2008 16:29:55 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] License of changes to ath5k/ath9k
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org,
	bkuhn@softwarefreedom.org
In-Reply-To: <20081125210421.GF5950@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081125210421.GF5950@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2008 at 4:04 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> We'll keep using the ath5k Changes-licensed-under tag until we get
> advice from SFLC if we have done enough to ensure this is no longer
> necessary. For ath9k, if we are not sure if you have read the
> "Developer's Certificate of Origin 1.1" we may ping you with an e-mail
> just to be sure.

I don't consider any of my changes significant enough to confer copyright,
so by my Signed-off-by, I agree that whatever license the file currently
has is alright by me.  Even if the changes were significant, the previous
holds.

However, if everyone + SFLC prefers that we strictly use
Changes-licensed-under even if we don't claim copyright, then I'll
happily add the tag generator script to a git commit hook :)

> Ps. Please do not open any can of worms here, this is just informational.

Sure.  I like the ath9k way, but really it doesn't matter that much.

-- 
Bob Copeland %% www.bobcopeland.com
