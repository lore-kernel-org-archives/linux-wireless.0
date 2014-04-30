Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s13.blu0.hotmail.com ([65.55.111.88]:14047 "EHLO
	blu0-omc2-s13.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759235AbaD3Rux convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 13:50:53 -0400
Message-ID: <BLU0-SMTP5388FC10A36BF1D90FE79FA9410@phx.gbl> (sfid-20140430_195056_845767_E8F61E12)
Date: Wed, 30 Apr 2014 14:50:46 -0300
From: Nicolas Vaquero <nicovaq92@hotmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Sven Eckelmann <sven@narfation.org>
CC: Tim Gardner <rtg.canonical@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel source
References: <535E7741.1030607@lwfinger.net> <3262959.TlL8alHHte@bentobox> <53610B15.4000607@lwfinger.net>
In-Reply-To: <53610B15.4000607@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you want, I can reinstall Ubuntu 12.04 and update it to the lastest 
Kernel version from Update Manager.
Teach me how to make a Bug Report and I'll send it to you.
(Sorry for my English, maybe your eyes are bleeding)

Nicolas

El 30/04/14 11:39, Larry Finger escribió:
> Sven and Tim,
>
> Attached is a one-line fix for the problem that shows up between 
> 3.8.0-36 and 3.8.0-37. It is just a bare patch file, but feel free to 
> add any explanatory text to make it a proper commit.
>
> I have no real understanding as to why this line of code does not 
> cause any problems with later kernel versions, but it does here. In 
> addition, I have not had any reports of problems with other users. 
> That makes me suspect some kind of bad interaction with the user-space 
> network control components in 12.04.
>
> Would it be helpful for Nicolas to prepare a bug report at Ubuntu?
>
> Larry
>
>

