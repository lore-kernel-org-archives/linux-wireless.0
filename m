Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38605 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYIJUpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 16:45:40 -0400
Received: by gxk9 with SMTP id 9so14825157gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Sep 2008 13:45:39 -0700 (PDT)
Message-ID: <43e72e890809101345i7b5ded8bnb7a8a4e7c16470ff@mail.gmail.com> (sfid-20080910_224544_602156_28B7FF6F)
Date: Wed, 10 Sep 2008 13:45:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Vasanthakumar Thiagarajan" <vasanth@atheros.com>
Subject: Re: [PATCH 1/2] ath9k: Re-order functions in main.c
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Jouni Malinen" <Jouni.Malinen@atheros.com>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <20080910131927.GA7779@vasanth-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080910131927.GA7779@vasanth-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 10, 2008 at 6:19 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> Some of the functions in main.c are re-ordered in such
> a way that all local functions are defined before mac80211
> and pci callbacks.

Please split the re-ordering of functions into a separate patch to
make it easier for review.

  Luis
