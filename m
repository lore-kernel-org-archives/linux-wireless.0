Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39902 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1ASLJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 06:09:39 -0500
Received: by qwa26 with SMTP id 26so697691qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 03:09:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110119092052.19628.61933.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
	<20110119092052.19628.61933.stgit@localhost6.localdomain6>
Date: Wed, 19 Jan 2011 06:09:38 -0500
Message-ID: <AANLkTinqj5TFBYYFvTMGX7_HEY1zTLsCP6v8aVKUogxW@mail.gmail.com>
Subject: Re: [PATCH 4/8] ath5k: ath5k_setup_channels cleanup and whitespace
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 19, 2011 at 4:20 AM, Bruno Randolf <br1@einfach.org> wrote:
> Remove useless test_bit - it's not going to happen because of the way this
> function is called only when that bit is set.
>
> And fix some whitespace.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
