Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38287 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYKSPqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 10:46:51 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Andy Johnson" <johnsonzjo@gmail.com>
Subject: Re: mac80211 MLME and user space
Date: Wed, 19 Nov 2008 16:45:58 +0100
Cc: linux-wireless@vger.kernel.org
References: <147a89290811181216i66a5a22cv77e6d06180b7b312@mail.gmail.com>
In-Reply-To: <147a89290811181216i66a5a22cv77e6d06180b7b312@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200811191645.58844.mb@bu3sch.de> (sfid-20081119_164654_751451_639FD699)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 18 November 2008 21:16:49 Andy Johnson wrote:
> My question is : why?

It's really similiar to the questions:
Why do we have udev? Why didn't we fix devfs instead?
Or why is hotplugging in userspace?

It's all basically, because we don't _need_ to have it in the kernel.
Having it in userspace means much easier code (often no locking needed).
Having it in userspace means, it's easily runtime replacable. Even after
crashes.
Having it in userspace means exploitable bugs are less likely to affect
the whole system.
There probably are a lot more reasons to do this.

-- 
Greetings Michael.
