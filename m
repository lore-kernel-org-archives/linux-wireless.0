Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45050 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab1BAOPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 09:15:13 -0500
Date: Tue, 1 Feb 2011 09:05:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Mohammed Shajakhan <Mohammed.Shajakhan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Fix memory leak due to failed PAPRD frames
Message-ID: <20110201140538.GA2560@tuxdriver.com>
References: <1296460529-13669-1-git-send-email-mshajakhan@atheros.com>
 <AANLkTimbtr8zKf6Nj0GmTccKU2u2ubTkL3a5BVSGfUK0@mail.gmail.com>
 <4D478F12.1070404@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D478F12.1070404@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 01, 2011 at 10:11:54AM +0530, Mohammed Shafi wrote:
> On Tuesday 01 February 2011 12:13 AM, Luis R. Rodriguez wrote:
> >On Sun, Jan 30, 2011 at 11:55 PM, Mohammed Shafi Shajakhan
> ><mshajakhan@atheros.com>  wrote:
> >>From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> >>
> >>free the skb's when the Tx of PAPRD frames fails and also add a debug
> >>message indicating that.
> >>
> >>Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> >Is this a stable fix?
> No Luis, this problem came from some recent changes in PAPRD before
> that it was Ok.

The patch applied to wireless-2.6 without changes, and the error
handling for ath_tx_start matched existing usage.  So, I have it
queued now in wireless-2.6 with an added "Cc: stable@kernel.org".

Should I not?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
