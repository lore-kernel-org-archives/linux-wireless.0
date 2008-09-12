Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:36175 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbYILS5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 14:57:44 -0400
Received: by an-out-0708.google.com with SMTP id d40so120574and.103
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2008 11:57:41 -0700 (PDT)
Message-ID: <69e28c910809121157qaaad7c8w67d626e60e807892@mail.gmail.com> (sfid-20080912_205747_776282_8E3CD289)
Date: Fri, 12 Sep 2008 20:57:40 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Mike Cui" <cuicui@gmail.com>
Subject: Re: BMC4310 support (03f0:171d)
Cc: "Nadav Kavalerchik" <nadavkav@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <7c8826910809120133o13c744d0pbfae5a18dd72787f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4219988b0809011331j4acb1582u3239218c6b7ff573@mail.gmail.com>
	 <4219988b0809011349i640d36e0p497eb8cefe303d0@mail.gmail.com>
	 <200809012333.58897.mb@bu3sch.de>
	 <4219988b0809091240s970c580k763054a56ef740b3@mail.gmail.com>
	 <4219988b0809091241l565fa8fcpebe2fb552782c4d4@mail.gmail.com>
	 <7c8826910809120133o13c744d0pbfae5a18dd72787f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 12, 2008 at 10:33 AM, Mike Cui <cuicui@gmail.com> wrote:
> What's the PCI ID? I have a BCM 4315 which is misidentified as BCM4310
> by lspci. In any case,  Dell releases NDIS 5.1 drivers for broadcom,
> while HP doesn't. Try googling for Dell wireless 1395. It works for
> me.

It is not a "BCM4315", it is a BCM4310. There is no such thing as a
BCM4315. Chip ID != PCI ID!
Most chip IDs match with their respective PCI IDs, but here are some exceptions:
0x4320 is BCM4306.
0x4315 is BCM4310.
0x4328 is BCM4321.
0x432b is BCM4322.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
