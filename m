Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:43259 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZINJUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 05:20:52 -0400
Received: by iwn8 with SMTP id 8so1235303iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 02:20:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909140149t7459b36fgbcca27adb7937d9b@mail.gmail.com>
References: <43e72e890909140149t7459b36fgbcca27adb7937d9b@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 14 Sep 2009 02:20:35 -0700
Message-ID: <43e72e890909140220r101ce489je671153c0ba56e4b@mail.gmail.com>
Subject: Re: pending patches for atheros - all-in-one file - 2009-09-14
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, devel@linuxdriverproject.org
Cc: Sujith <Sujith.Manoharan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2009 at 1:49 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> This file has all pending patches from my series + sujiths ANI fix patch:
>
> http://bombadil.infradead.org/~mcgrof/patches/ath/2009/09/all-pending-2009-09-14.patch

Except it doesn't obviously have the updated ath5k ops patch I just
posted nor the last const patch, here is the new all-in-one with these
changes:

http://bombadil.infradead.org/~mcgrof/patches/ath/2009/09/all-2009-09-14v2.patch

  Luis
