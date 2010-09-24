Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:55419 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab0IXRn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 13:43:56 -0400
Subject: Re: problem with b43
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev@lists.infradead.org
In-Reply-To: <AANLkTinxr6avpgR9v3nBaNp8nSORFkStDcOsL2KW0-Ln@mail.gmail.com> (sfid-20100924_133117_545401_3DF5F369)
References: <20100924185551.e3c3b41c.cyrille@cbiot.fr>
	 <AANLkTik5QPw6K_CFQW-5qH3PhyDAguqe51AcNaDMOUqt@mail.gmail.com>
	 <20100924172132.GC8077@tuxdriver.com>
	 <AANLkTinxr6avpgR9v3nBaNp8nSORFkStDcOsL2KW0-Ln@mail.gmail.com>
	 (sfid-20100924_133117_545401_3DF5F369)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 19:43:50 +0200
Message-ID: <1285350230.9528.3.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-24 at 19:30 +0200, Gábor Stefanik wrote: 
> OpenFWWF definitely won't work with LP-PHYs. We don't even know enough
> about LP-PHY to fix the DMA error, let alone to write our own
> firmware...

Well, the firmware is pretty much independent of the PHY that is used
(except for some workarounds and some minor stuff).
The firmware does only depend on the wireless MAC core revision.
What 80211 core rev do LP PHY devices typically have?

-- 
Greetings Michael.

