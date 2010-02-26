Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42426 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935925Ab0BZMzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 07:55:23 -0500
Received: by bwz1 with SMTP id 1so35511bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 04:55:21 -0800 (PST)
From: Holger Schurig <holgerschurig@googlemail.com>
To: Bing Zhao <bzhao@marvell.com>
Subject: Re: [PATCH] libertas: add auto auth mode feature
Date: Fri, 26 Feb 2010 13:55:06 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
References: <1267146996-3725-1-git-send-email-bzhao@marvell.com>
In-Reply-To: <1267146996-3725-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201002261355.06127.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Auto auth mode is enabled by default. If user doesn't specify the
> auth mode, while association driver will first try with open mode
> and then with shared key mode. If user specifies an auth mode,
> auto auth is disabled and driver will not try association with
> another auth mode.

I'd rather would like if you guys chime in into the cfg80211 port rather 
than adding stuff to assoc.c and wext.c, which hopefully get's removed 
really soon now.


As a side note: I'm now inclined to get rid of Libertas' proprietary mesh 
support in the driver. I don't know no one except OLPC that uses it, and 
even they don't seem work with upstream. For me, this mesh stuff is the last 
obstacle for cfg80211 support in libertas.
