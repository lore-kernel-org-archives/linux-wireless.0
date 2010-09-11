Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45411 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0IKTQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 15:16:35 -0400
Received: by qyk36 with SMTP id 36so538004qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 11 Sep 2010 12:16:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284231996-29010-1-git-send-email-me@bobcopeland.com>
References: <1284231996-29010-1-git-send-email-me@bobcopeland.com>
Date: Sat, 11 Sep 2010 15:16:33 -0400
Message-ID: <AANLkTimU8ngOJKZZv8f23fgOuyH0pMa=sAVREDq63P_S@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: reorder base.c to remove fwd decls
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, br1@einfach.org
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 11, 2010 at 3:06 PM, Bob Copeland <me@bobcopeland.com> wrote:
> This change reorganizes the main ath5k file in order to re-group
> related functions and remove most of the forward declarations
> (from 61 down to 3).  This is, unfortunately, a lot of churn, but
> there should be no functional changes.

Forgot to mention, this is based on Bruno's ath?k crypto series.

-- 
Bob Copeland %% www.bobcopeland.com
