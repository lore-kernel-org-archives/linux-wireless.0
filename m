Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:54632 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbZJ0DOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 23:14:42 -0400
Received: by iwn10 with SMTP id 10so6422457iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 20:14:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910270508.29029.denys@visp.net.lb>
References: <200910270259.09787.denys@visp.net.lb> <200910270410.24274.denys@visp.net.lb>
	<43e72e890910261959s6490b900xebb365d288c03f@mail.gmail.com>
	<200910270508.29029.denys@visp.net.lb>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Oct 2009 20:14:27 -0700
Message-ID: <43e72e890910262014y77ef048do965a76ab423c2db6@mail.gmail.com>
Subject: Re: ath5k, too high output power?
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 8:08 PM, Denys Fedoryschenko <denys@visp.net.lb> wrote:
> On Tuesday 27 October 2009 04:59:20 Luis R. Rodriguez wrote:
>> You mean can you do antenna diversity and select this manually ? I am
>> not sure, but I doubt it, should be easy to add though.
>
> Yes, on some laptops wireless card connected really weird way. And while on
> Windows everything worked fine, on Linux signal was too weak, and some people
> thinking it is driver issue.
> I had this issue with madwifi before, and choosing antenna manually helped.
> But it was long time ago, no idea if it's useful now in ath5k. But in custom
> boards like Routerboard it is very useful.

ath5k and madwifi are very different.

  Luis
