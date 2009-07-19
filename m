Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:51640 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbZGSVar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 17:30:47 -0400
Received: by gxk9 with SMTP id 9so3367485gxk.13
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2009 14:30:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090718221212.10818.52921.stgit@mj.roinet.com>
References: <20090718221212.10818.52921.stgit@mj.roinet.com>
Date: Sun, 19 Jul 2009 17:30:47 -0400
Message-ID: <b6c5339f0907191430jc68da1ao12b304d65974a5eb@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fix values for bus error bits in ISR2
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 18, 2009 at 6:12 PM, Pavel Roskin<proski@gnu.org> wrote:
> The new values are taken from the recently open sourced Atheros HAL.
> Correctness is also confirmed by the users with access to Atheros
> documentation.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Acked-by: Bob Copeland <me@bobcopeland.com>

Thanks!

-- 
Bob Copeland %% www.bobcopeland.com
