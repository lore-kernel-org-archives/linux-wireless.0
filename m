Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:48534 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbZIRH72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 03:59:28 -0400
Received: by iwn8 with SMTP id 8so577526iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 00:59:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19121.45772.489140.407518@gargle.gargle.HOWL>
References: <19121.45772.489140.407518@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 18 Sep 2009 00:59:11 -0700
Message-ID: <43e72e890909180059h31f7d80bre1bab46e7e89c699@mail.gmail.com>
Subject: Re: [PATCH 00/12] ath9k bug fixes
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 16, 2009 at 8:53 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> John,
>
> A bunch of patches fixing various bugs in the driver.
> These apply on top of wireless-testing.
>
> Luis would rebase his pending patches on top of these
> and resend them.

John, here is my rebase of my 48 patches on top of this series. I
won't post them and instead give you this handy git am'able file.

http://bombadil.infradead.org/~mcgrof/patches/ath/2009/09/all-2009-09-18-mcgrof-rebased.patch

If you really need me to post them again please let me know.

If you want to get both sujith's collection series + mine in one file
here they are:

http://bombadil.infradead.org/~mcgrof/patches/ath/2009/09/all-2009-09-18.patch

  Luis
