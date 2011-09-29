Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35173 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1I2LpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 07:45:05 -0400
Received: by yxl31 with SMTP id 31so503225yxl.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2011 04:45:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1125417094.1836.1317285426615.JavaMail.root@idefix>
References: <CAB=NE6U6qmYbvHPTWGTqOdXtuxbKYbUzZXNiE6POOX9QZNRWAg@mail.gmail.com>
	<1125417094.1836.1317285426615.JavaMail.root@idefix>
Date: Thu, 29 Sep 2011 19:45:04 +0800
Message-ID: <CAJ-VmonqEs4mODDa2=fTj8zWHwRM7-G5e=BWNUyGdy65+kYvfg@mail.gmail.com> (sfid-20110929_134509_380070_01216667)
Subject: Re: Regulatory revamp status
From: Adrian Chadd <adrian@freebsd.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Boris Presman <boris.presman@ti.com>,
	Assaf Azulay <assaf@ti.com>,
	Michael Green <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Arun Venkataraman <arunvenk@qca.qualcomm.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 September 2011 16:37, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> Thanks for the update.
>
> To me it looks not reasonable to mix in between the two approaches: either we assume countrycodes use the same DFS region for all channels, or each channel/band needs to have its own. Otherwise I feel that a DFS region bitmap would give a semi-flexible compromise that might end up being insufficient to represent some fancy countrycodes.

There's some funny stuff in there.

For example, some of the DFS bands have different CAC/NOL timing. :-)



Adrian
