Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:46768 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370AbZLNO6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 09:58:43 -0500
Received: by iwn1 with SMTP id 1so196373iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 06:58:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19238.1248.439940.601526@gargle.gargle.HOWL>
References: <19238.1248.439940.601526@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 14 Dec 2009 06:58:22 -0800
Message-ID: <43e72e890912140658xa88e8feq9589b29448d5d7e4@mail.gmail.com>
Subject: Re: [PATCH 1/6] ath9k: Fix bug in assigning sequence number
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 14, 2009 at 1:26 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> The internal, driver-specific maintenance of sequence
> numbers is applicable only for HT frames.
>
> Also, remove comments that are not relevant anymore.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Is this cc: stable?

  Luis
