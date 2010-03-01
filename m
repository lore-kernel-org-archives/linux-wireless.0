Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f179.google.com ([209.85.222.179]:57629 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0CAWdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 17:33:44 -0500
Received: by pzk9 with SMTP id 9so2303728pzk.25
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 14:33:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891003010939p6367147cgda88272092c6578f@mail.gmail.com>
References: <19339.35501.467215.380773@gargle.gargle.HOWL>
	<43e72e891003010939p6367147cgda88272092c6578f@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Mar 2010 14:33:23 -0800
Message-ID: <43e72e891003011433h5186545eoc1937b319c782e31@mail.gmail.com>
Subject: Re: [PATCH 1/7] ath9k: Add common code to lib
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 1, 2010 at 9:39 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, Mar 1, 2010 at 1:36 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
>> Move a few macros to the common library to be shared
>> between ath9k and ath9k_htc.
>>
>> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
>
> I think you forgot to git add the lib.[ch] files.

Nevermind -- the code is already there on lib.c.

  Luis
