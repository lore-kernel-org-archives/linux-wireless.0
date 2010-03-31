Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1187 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317Ab0CaRW5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 13:22:57 -0400
Subject: Re: Intel Corporation PRO/Wireless 4965 AG or AGN randomly shuts
 off
From: reinette chatre <reinette.chatre@intel.com>
To: Jeremi Thebeau <jeremi.thebeau@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <m2j4c251d3f1003302243z67d9c5f0v93cec04fb3543ceb@mail.gmail.com>
References: <m2j4c251d3f1003302243z67d9c5f0v93cec04fb3543ceb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Mar 2010 10:22:56 -0700
Message-ID: <1270056176.2446.3494.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jeremi,

On Tue, 2010-03-30 at 22:43 -0700, Jeremi Thebeau wrote:

> jeremi@linux64:~$ uname -a
> Linux linux64 2.6.31-20-generic #58-Ubuntu SMP Fri Mar 12 04:38:19 UTC
> 2010 x86_64 GNU/Linux
> 
> with Ubuntu Karmic 64 bit.

Is it possible to give the latest driver code a try to ensure we are
dealing with the latest features? compat-wireless may be an easy way for
you to do this. 

We have seen some devices that essentially get disconnected from the
platform, which seems to be happening here. We prepared a patch for this
a while ago, but nobody with this issue has yet been able to test it.
Perhaps you could? Please try
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2037#c112 ...
hopefully it will still be straight forward to apply.

Reinette


