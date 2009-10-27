Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:57848 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbZJ0C7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 22:59:36 -0400
Received: by iwn10 with SMTP id 10so6415596iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 19:59:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910270410.24274.denys@visp.net.lb>
References: <200910270259.09787.denys@visp.net.lb> <43e72e890910261838k7986048dg4cc38634d828e98c@mail.gmail.com>
	<200910270410.24274.denys@visp.net.lb>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Oct 2009 19:59:20 -0700
Message-ID: <43e72e890910261959s6490b900xebb365d288c03f@mail.gmail.com>
Subject: Re: ath5k, too high output power?
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 7:10 PM, Denys Fedoryschenko <denys@visp.net.lb> wrote:
> On Tuesday 27 October 2009 03:38:02 Luis R. Rodriguez wrote:
>> You obviously can change the antenna on a lot of devices, sometimes
>> that is difficult due to the connectors used but you are likely to
>> find them online somewhere.
>
> I mean A or B :-) AUX or MAIN :-)
> Sorry for my ugly English.
> In madwifi, as i remember i was possible to do that or over sysctl or over
> module parameter, i dont remember exactly where.

You mean can you do antenna diversity and select this manually ? I am
not sure, but I doubt it, should be easy to add though.

  Luis
