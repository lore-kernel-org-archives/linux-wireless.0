Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:53852 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbYIMDLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 23:11:52 -0400
Received: by ug-out-1314.google.com with SMTP id k3so136516ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2008 20:11:50 -0700 (PDT)
Message-ID: <7c8826910809122011i23587a6bta838f2e0a7c39744@mail.gmail.com> (sfid-20080913_051204_550034_5DF6AE9D)
Date: Fri, 12 Sep 2008 20:11:50 -0700
From: "Mike Cui" <cuicui@gmail.com>
To: "=?UTF-8?Q?Stefanik_G=C3=A1bor?=" <netrolller.3d@gmail.com>
Subject: Re: BMC4310 support (03f0:171d)
Cc: "Nadav Kavalerchik" <nadavkav@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910809121157qaaad7c8w67d626e60e807892@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4219988b0809011331j4acb1582u3239218c6b7ff573@mail.gmail.com>
	 <4219988b0809011349i640d36e0p497eb8cefe303d0@mail.gmail.com>
	 <200809012333.58897.mb@bu3sch.de>
	 <4219988b0809091240s970c580k763054a56ef740b3@mail.gmail.com>
	 <4219988b0809091241l565fa8fcpebe2fb552782c4d4@mail.gmail.com>
	 <7c8826910809120133o13c744d0pbfae5a18dd72787f@mail.gmail.com>
	 <69e28c910809121157qaaad7c8w67d626e60e807892@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It is not a "BCM4315", it is a BCM4310. There is no such thing as a
> BCM4315. Chip ID != PCI ID!
> Most chip IDs match with their respective PCI IDs, but here are some exceptions:
> 0x4320 is BCM4306.
> 0x4315 is BCM4310.
> 0x4328 is BCM4321.
> 0x432b is BCM4322.

Maybe...

But on the miniPCIe chip itself, there is a sticker that says Broadcom
4312. But it's not a BCM4312 either, because BCM4312 actually works...
