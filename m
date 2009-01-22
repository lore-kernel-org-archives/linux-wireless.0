Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:10880 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbZAVEc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 23:32:57 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1866707ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 20:32:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c910901211133n25c1a151nc9ca7172a9de7d3a@mail.gmail.com>
References: <200901140003.31693.gbburkhardt@verizon.net>
	 <200901151734.46144.gbburkhardt@verizon.net>
	 <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com>
	 <200901202238.08756.gbburkhardt@verizon.net>
	 <20090121151435.GB3643@tuxdriver.com>
	 <69e28c910901211022j7f9c67dfv6392ce043dcff522@mail.gmail.com>
	 <20090121191141.GA14710@tuxdriver.com>
	 <69e28c910901211133n25c1a151nc9ca7172a9de7d3a@mail.gmail.com>
Date: Thu, 22 Jan 2009 06:32:55 +0200
Message-ID: <40f31dec0901212032j65371fc6j5fcc1952f841d2ef@mail.gmail.com> (sfid-20090122_053650_200994_AAE815C2)
Subject: Re: poor performance with ath5k; reverting to ath_pci
From: Nick Kossifidis <mickflemm@gmail.com>
To: =?UTF-8?Q?Stefanik_G=C3=A1bor?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Glenn Burkhardt <gbburkhardt@verizon.net>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/21 Stefanik G=C3=A1bor <netrolller.3d@gmail.com>:
>
> I think EMBEDDED is for options that replace full-featured Linux
> components with dumbed-down, "low-profile" equivalents (like SLOB) -
> PID vs. minstrel is more like SLAB vs. SLUB.
>
> G=C3=A1bor
>

Minstrell performs very well even on embedded devices, i don't think
it's that heavy compared to pid.



--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
