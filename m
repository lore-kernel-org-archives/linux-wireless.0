Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59114 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1BZJpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 04:45:07 -0500
Received: by bwz15 with SMTP id 15so2569669bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 Feb 2011 01:45:05 -0800 (PST)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH 0/3] libertas_spi fixes
Date: Sat, 26 Feb 2011 11:44:43 +0200
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com> <201102032059.27128.anarsoul@gmail.com> <201102081352.51062.marek.vasut@gmail.com>
In-Reply-To: <201102081352.51062.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201102261144.43721.anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 February 2011 14:52:50 Marek Vasut wrote:
 
> > Nope, it can't, I tried to do so and it hangs on resume (console cursor
> > flickers, so it's not complete hang, but it does not return control to
> > shell). Can investigate why if you want.
> 
> Please do. It's not that I want to block this, but the code seems quick
> enough.
> 
> Btw. Dan, sorry for not looking into this as I promised, but as I can see,
> it isn't needed anymore. Open Source is so awesome at this :-)

Hi,

and sorry for a long delay.

It fails on firmware request, looks like pxa2xx-mci driver is not ready yet. 
It works OK without workqueue if I compile firmware into kernel (but it's not 
a way to go, right?)

Regards
Vasily
