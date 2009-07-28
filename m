Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:43911 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbZG1XxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 19:53:20 -0400
Received: by ewy26 with SMTP id 26so449529ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 16:53:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907280838.42541@fortytwo.ch>
References: <200907280838.42541@fortytwo.ch>
Date: Wed, 29 Jul 2009 02:53:18 +0300
Message-ID: <40f31dec0907281653g63375736id57f547a8ba12cad@mail.gmail.com>
Subject: Re: ath5k connection loss (failed to wakeup the MAC Chip)
From: Nick Kossifidis <mickflemm@gmail.com>
To: Adrian von Bidder <avbidder@fortytwo.ch>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/28 Adrian von Bidder <avbidder@fortytwo.ch>:
> Heyho!
>
> (This is using kernel 2.6.31-rc3 as packaged by Debian)
>
> While taking a full backup of my laptop, I noticed that after a few 100M the
> ath5k can't connect to WLAN anymore.
>

[...]

> This only happens with bulk data transfers, and probably only when sending.
> Downloading large dataset over WLAN is fine (I haven't tested it as much as
> sending, though: downloads are mostly small, while the bulk sending happens
> regularly during backup.)
>
> It is not related to how long the WLAN is up: I can work for days or weeks
> (happened with earlier kernels as well) with this laptop, over
> suspend/resume, and WLAN works fine.  It's only when I run backup that it
> happens (always - but I since backups usually are incremental, they're often
> small enough.  But once I do a full backup WLAN goes down.  So use cable for
> those...)
>
> Is this known?  Can I get you more information?
>
> Hardware is Acer AOA 150.
>
> thanks

Working on it, can you please post the part when ath5k loads ?


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
