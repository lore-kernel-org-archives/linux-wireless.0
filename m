Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50471
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbXEZRSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 13:18:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 19:18:09 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>
References: <20070524195616.234280@gmx.net> <200705261840.45896.mb@bu3sch.de> <200705261904.04496.uwe.bugla@gmx.de>
In-Reply-To: <200705261904.04496.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705261918.09469.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 May 2007 19:04:04 Uwe Bugla wrote:
> Yes, sure! But the help text is very unlucky and humble, and it is not clear 
> enough in the sense of being distinctive enough, just clear and 
> comprehensive.

Why don't you simply submit a patch to change the helptext then?
I'm not sure why you refuse to DO anything about the "mess", but
instead keep poking me that I am responsible somehow to fix it up
for you...

> >
> > So I'm not sure why you keep bashing the kconfig implementation
> > here. It's common practice to have seperate config options for
> > bus-glues and it _automatically_ selects the right options for
> > you.
> 
> Yes! But you need to EXPLAIN that "bus-glue" in the Kconfig help text in some 
> two or three sentences. That shouldn't be that hard, should it?

Ok, go for it.

-- 
Greetings Michael.
