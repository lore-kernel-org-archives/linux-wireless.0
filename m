Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46967 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0LXMAC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Dec 2010 07:00:02 -0500
Received: by qyj19 with SMTP id 19so8603055qyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Dec 2010 04:00:01 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <28292.82403.qm@web56807.mail.re3.yahoo.com>
References: <AANLkTimL=JSK6jcF4d97Nc-vLZdeRLj8o=MbpCas-H7z@mail.gmail.com>
	<28292.82403.qm@web56807.mail.re3.yahoo.com>
Date: Fri, 24 Dec 2010 13:00:01 +0100
Message-ID: <AANLkTi=GgTWU1QmoqxM_rA8jUX7814PvZqsEGvcnc6ps@mail.gmail.com>
Subject: Re: carl9170 and debian squeeze
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org, Der Engel <engelster@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 24, 2010 at 12:29 PM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
> This is because of driver-select. To make a long story short, download and install the entire compat-wireless suit (without driver select). If the current version fails to compile download the one from the day before and so on until you find a version which compiles entirely. Then you'll have support for all of your wireless cards.
>
>
> Walter
>

I always wonder why people start with bleeding-edge version of compat-wireless.
A daily bleeding-edge version might be broken, try a previous version
(as Walter recommended).
Check also the automated reports of Luis which are sent to this ML.
There are "half-baked" version around...

"Der" did you try a stable .36 or stable .37-rcX of c-w?

So you asked for carl9170 and not in combination with iwlwifi!
For a new topic open a new thread, please.
As Walter pointed out, do a full compilation of c-w.


- Sedat -
