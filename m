Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:38446 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZBMFpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 00:45:36 -0500
Received: by gxk22 with SMTP id 22so492818gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 21:45:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234463938-1350-4-git-send-email-me@bobcopeland.com>
References: <1234463938-1350-4-git-send-email-me@bobcopeland.com>
Date: Thu, 12 Feb 2009 21:45:35 -0800
Message-ID: <43e72e890902122145n33a6d99ao5ae883c33a6125b7@mail.gmail.com> (sfid-20090213_064540_500089_9C80563B)
Subject: Re: [ath5k-devel] [PATCH 3/6] ath9k: convert isWwrSKU macro into C
	code
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 10:38 AM, Bob Copeland <me@bobcopeland.com> wrote:
> Write isWwrSKU as an inline function and nix the camel-case to make
> the routine slightly clearer.  Change its argument to take the regd
> value directly so it can eventually be used by ath5k as well.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
