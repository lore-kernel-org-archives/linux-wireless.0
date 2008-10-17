Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:21407 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbYJQTdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 15:33:18 -0400
Received: by rv-out-0506.google.com with SMTP id k40so718326rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 12:33:18 -0700 (PDT)
Message-ID: <b6c5339f0810171233v59e80b4bxce7bdb049e38a5f7@mail.gmail.com> (sfid-20081017_213323_611511_B33D3EA7)
Date: Fri, 17 Oct 2008 15:33:18 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "John Daiker" <daikerjohn@gmail.com>
Subject: Re: [PATCH] ath5k: reduce checkpatch.pl errors
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <48F8E470.8000103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48F8E470.8000103@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 17, 2008 at 3:16 PM, John Daiker <daikerjohn@gmail.com> wrote:
> A few changes to reduce checkpatch.pl errors in the ath5k driver.  For the
> most part, I only fixed cosmetic things, and left the actual 'code flow'
> untouched (hopefully)!
>
> Diff is against wireless-testing HEAD.
>
> Signed-off-by: John Daiker <daikerjohn@gmail.com>

Please post patches inline if you can; they are easier to review that way.

One easy way to convince yourself (and us) that there are no code changes
is to compile with and without the patch and compare resulting binaries
for no differences.

All that said, I reviewed this one and it looks good...

Reviewed-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
