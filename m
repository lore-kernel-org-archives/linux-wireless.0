Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.229]:48109 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXKAEme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 00:42:34 -0400
Received: by wx-out-0506.google.com with SMTP id h31so407579wxd
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 21:42:33 -0700 (PDT)
Date: Thu, 1 Nov 2007 00:42:27 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 0/7] ath5k: Few patches which start fixing G mode
Message-ID: <20071101044227.GI21987@pogo> (sfid-20071101_044252_294569_9909A889)
References: <20071101043157.GA21987@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071101043157.GA21987@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 01, 2007 at 12:31:57AM -0400, Luis R. Rodriguez wrote:
> Here are a few patches which start fixing G mode settings.

Forgot to mention these depend on Nick's 1-7 series patches plus,

[PATCH] ath5k: Remove fill_tx_desc
[PATCH] ath5k: 4word tx descriptor setup doesn't set BUF_LEN

The last one by Ulrich Meis.

I've also tested these patches on AR5211, AR5212, and on big-endian.

  Luis
