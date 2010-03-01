Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f188.google.com ([209.85.216.188]:58460 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab0CARkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 12:40:03 -0500
Received: by pxi26 with SMTP id 26so956418pxi.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 09:40:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19339.35501.467215.380773@gargle.gargle.HOWL>
References: <19339.35501.467215.380773@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Mar 2010 09:39:42 -0800
Message-ID: <43e72e891003010939p6367147cgda88272092c6578f@mail.gmail.com>
Subject: Re: [PATCH 1/7] ath9k: Add common code to lib
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 1, 2010 at 1:36 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Move a few macros to the common library to be shared
> between ath9k and ath9k_htc.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

I think you forgot to git add the lib.[ch] files.

  Luis
