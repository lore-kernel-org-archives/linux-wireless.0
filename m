Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62173 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0IXRbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 13:31:17 -0400
Received: by qyk36 with SMTP id 36so1607022qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 10:31:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100924172132.GC8077@tuxdriver.com>
References: <20100924185551.e3c3b41c.cyrille@cbiot.fr> <AANLkTik5QPw6K_CFQW-5qH3PhyDAguqe51AcNaDMOUqt@mail.gmail.com>
 <20100924172132.GC8077@tuxdriver.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 24 Sep 2010 19:30:56 +0200
Message-ID: <AANLkTinxr6avpgR9v3nBaNp8nSORFkStDcOsL2KW0-Ln@mail.gmail.com>
Subject: Re: problem with b43
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Cyrille <cyrille@cbiot.fr>, b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/24 John W. Linville <linville@tuxdriver.com>:
> On Fri, Sep 24, 2010 at 07:06:17PM +0200, Gábor Stefanik wrote:
>> On Fri, Sep 24, 2010 at 6:55 PM, Cyrille <cyrille@cbiot.fr> wrote:
>> > Hi
>> > I've got a problem with a broadcom 4312 [12e4:4315].
>> > The environment :
>> > ===========================
>> > uname -a
>> > 2.6.35.5-libre.29.fc14.x86_64
>
>> > Broadcom 43xx driver loaded [ Features: PMLS, Firmware-ID: FW13 ]
>> > ssb0:0: Missing Free firmware
>> > b43-phy4 ERROR: Rejected non-Free firmware
>> > ssb0:0: Missing Free firmware
>> > b43-phy4 ERROR: Rejected non-Free firmware
>>
>> Compile compat-wireless to bypass the "free-only" patch in Fedora.
>>
>> (John, are you still maintaining the Fedora kernel's wireless part? If
>> so, please kill this "freedom enforcement"!)
>
> This isn't a Fedora kernel.  I'm guessing it is from "Free-dora"
> by way of BLAG, and I have no control over it -- sorry.
>
> Cyrille, did you try b43-openfwwf?  If that doesn't work, then you
> will need to use extracted proprietary firmware with some other kernel
> (e.g. stock Fedora) or you will have to live without b43.

OpenFWWF definitely won't work with LP-PHYs. We don't even know enough
about LP-PHY to fix the DMA error, let alone to write our own
firmware...

>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
