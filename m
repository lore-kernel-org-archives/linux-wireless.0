Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58825 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab1JQOf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 10:35:57 -0400
Received: by wyg36 with SMTP id 36so2268164wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 07:35:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111017162727.388624fc@milhouse>
References: <1318800649-5609-1-git-send-email-zajec5@gmail.com>
	<20111017162727.388624fc@milhouse>
Date: Mon, 17 Oct 2011 16:35:55 +0200
Message-ID: <CACna6ryM-08U+Ohtm6LYTuoDqy1uFfFd4jP5PmD-X=CuNT7omA@mail.gmail.com> (sfid-20111017_163605_281359_6CB5D1B1)
Subject: Re: [PATCH 3.2 REQUEST] b43: HT-PHY: report signal to mac80211
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	David Woodhouse <dwmw2@infradead.org>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 17 października 2011 16:27 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Sun, 16 Oct 2011 23:30:49 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>> +     case B43_PHYTYPE_HT:
>> +             /* TODO: is max the right choice? */
>> +             status.signal = max(
>> +                     (__s8) max(rxhdr->phy_ht_power0, rxhdr->phy_ht_power1),
>
> Hm, why is this cast needed? Does it throw a warning?

warning: comparison of distinct pointer types lacks a cast

gcc 4.5.1

-- 
Rafał
