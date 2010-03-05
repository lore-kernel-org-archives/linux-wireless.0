Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40436 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab0CENPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 08:15:16 -0500
Received: by gwb15 with SMTP id 15so1798609gwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Mar 2010 05:15:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6b5e31691003040621ge2ca051n1bb3abb4b0158546@mail.gmail.com>
References: <6b5e31691003010730ie73ff4cld32e3a9d38def7d0@mail.gmail.com>
	 <b6c5339f1003031530l2a89c265t98a8560bdbf9c758@mail.gmail.com>
	 <6b5e31691003040621ge2ca051n1bb3abb4b0158546@mail.gmail.com>
Date: Fri, 5 Mar 2010 08:15:15 -0500
Message-ID: <b6c5339f1003050515m7ec8518fy5bd29c6886228e4f@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fixing retries in ath5k_hw_setup_4word_tx_desc
From: Bob Copeland <me@bobcopeland.com>
To: Andrew Blaich <ablaich@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great, but:

On Thu, Mar 4, 2010 at 9:21 AM, Andrew Blaich <ablaich@gmail.com> wrote:
> Updating the patch to include the removal of  the define of
> AR5K_TUNE_HWTXTRIES per Benoit's suggestion as the patch makes it no
> longer necessary.

Please repost the patch as a follow-up to the thread, but
without the quoted discussion.  This allows John to take the
email directly once it's ready, without editing the text.

You should always write the description as if it were going
into the commit log as-is.  If you include changelog
information (and you should), put it after the '---' with
the diffstat.  E.g.

ath5k: title here.

The original description of the brokenness of the tunable
here, written as if no one knew about the first patch.

Signed-off-by: here

---
Anything you want to write can go here, it will get
removed by git-am.

v2: remove AR5K_TUNE_HWTXTRIES per Benoit's comments

[diffstat]
---
[patch]

> Signed-off-by:: Andrew Blaich <ablaich@gmail.com>

"Signed-off-by:" i.e. one ':'

Also you should avoid a lead-in like "This patch" to the
extent possible.  See:

http://userweb.kernel.org/~akpm/stuff/tpp.txt

-- 
Bob Copeland %% www.bobcopeland.com
