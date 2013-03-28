Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab3C1Lco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 07:32:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: sedat.dilek@gmail.com
Subject: Re: [PATCH] mac80211: fix uninitialized variable
Date: Thu, 28 Mar 2013 11:32:38 +0000
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Vincent <vincent.stehle@laposte.net>,
	linux-wireless@vger.kernel.org
References: <1364461894-30555-1-git-send-email-vincent.stehle@laposte.net> <CA+icZUXZpYA8MVRk6++T5ykEEcTKL=gf4CqBMkexEr6N+GAd8A@mail.gmail.com> <CA+icZUUHrtKX_BUYzZQugmwwP9UG3Dyw7S4jwbs5japJS3ZGbw@mail.gmail.com>
In-Reply-To: <CA+icZUUHrtKX_BUYzZQugmwwP9UG3Dyw7S4jwbs5japJS3ZGbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303281132.38369.arnd@arndb.de> (sfid-20130328_123249_099020_EDE9F49E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 March 2013, Sedat Dilek wrote:
> On Thu, Mar 28, 2013 at 12:28 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> 
> [2] https://patchwork.kernel.org/patch/2274041/
>

There is a newer version with an updated description here:

https://patchwork.kernel.org/patch/2332071/

	Arnd
