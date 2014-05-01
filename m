Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:53399 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaEAMbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2014 08:31:33 -0400
Received: by mail-ob0-f179.google.com with SMTP id vb8so3520329obc.24
        for <linux-wireless@vger.kernel.org>; Thu, 01 May 2014 05:31:32 -0700 (PDT)
Date: Thu, 1 May 2014 07:31:27 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Nicolas Vaquero <nicovaq92@hotmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Sven Eckelmann <sven@narfation.org>,
	Tim Gardner <rtg.canonical@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel source
Message-ID: <20140501123127.GA47034@ubuntu-hedt> (sfid-20140501_143141_365200_B0741B66)
References: <535E7741.1030607@lwfinger.net>
 <3262959.TlL8alHHte@bentobox>
 <53610B15.4000607@lwfinger.net>
 <BLU0-SMTP5388FC10A36BF1D90FE79FA9410@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <BLU0-SMTP5388FC10A36BF1D90FE79FA9410@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 30, 2014 at 02:50:46PM -0300, Nicolas Vaquero wrote:
> If you want, I can reinstall Ubuntu 12.04 and update it to the
> lastest Kernel version from Update Manager.
> Teach me how to make a Bug Report and I'll send it to you.
> (Sorry for my English, maybe your eyes are bleeding)

To file the bug report against the kernel in Ubuntu, open a terminal and
run 'ubuntu-bug linux'. This will guide you through the process of
filing the bug.

Thanks,
Seth

> 
> Nicolas
> 
> El 30/04/14 11:39, Larry Finger escribió:
> >Sven and Tim,
> >
> >Attached is a one-line fix for the problem that shows up between
> >3.8.0-36 and 3.8.0-37. It is just a bare patch file, but feel free
> >to add any explanatory text to make it a proper commit.
> >
> >I have no real understanding as to why this line of code does not
> >cause any problems with later kernel versions, but it does here.
> >In addition, I have not had any reports of problems with other
> >users. That makes me suspect some kind of bad interaction with the
> >user-space network control components in 12.04.
> >
> >Would it be helpful for Nicolas to prepare a bug report at Ubuntu?
> >
> >Larry
> >
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
