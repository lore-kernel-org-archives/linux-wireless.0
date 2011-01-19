Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54540 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1ASLTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 06:19:18 -0500
Received: by qwa26 with SMTP id 26so706450qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 03:19:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110119092113.19628.33322.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
	<20110119092113.19628.33322.stgit@localhost6.localdomain6>
Date: Wed, 19 Jan 2011 06:19:17 -0500
Message-ID: <AANLkTikLXdfG-QOJFcdN0yJSspVCr419OyVZQ_LBvQtP@mail.gmail.com>
Subject: Re: [PATCH 8/8] ath5k: Remove redundant sc->curband
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 19, 2011 at 4:21 AM, Bruno Randolf <br1@einfach.org> wrote:
> Remove sc->curband because the band is already stored in the current channel.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>

Nice cleanup series!

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
