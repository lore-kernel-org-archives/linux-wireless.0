Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:60508 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab2LKUak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 15:30:40 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so3232835lag.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 12:30:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355107806-32675-1-git-send-email-sujith@msujith.org>
References: <1355107806-32675-1-git-send-email-sujith@msujith.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Tue, 11 Dec 2012 12:30:18 -0800
Message-ID: <CAB=NE6XTL5fyvNSdTm9Pa6wpaVKvv-X9Th9ZQi7zHT-OgSaUDw@mail.gmail.com> (sfid-20121211_213043_537161_053A8F5B)
Subject: Re: [PATCH] qca-swiss-army-knife: Update initvals for AR9340
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 9, 2012 at 6:50 PM, Sujith Manoharan <sujith@msujith.org> wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> The SLP32_MODE/INC registers have to be programmed with
> values based on the ref. clock, which could be either 25MHz
> or 40MHz. Incorrect values in these registers results in
> TSF drift.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Applied and pushed!

  Luis
