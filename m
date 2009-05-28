Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52923 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760756AbZE1Iph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 04:45:37 -0400
Date: Thu, 28 May 2009 10:40:51 +0200
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, dandart@googlemail.com,
	ivdoorn@gmail.com
Subject: Re: [Bugme-new] [Bug 13317] New: No rt2x00 modules in RT kernels.
Message-ID: <20090528084050.GA4401@tuxdriver.com>
References: <bug-13317-10286@http.bugzilla.kernel.org/> <20090528000253.c731179c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090528000253.c731179c.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 28, 2009 at 12:02:53AM -0700, Andrew Morton wrote:

> Presumably there's some bustage in the rt2x00 driver which makes it not
> work with -rt kernels.
> 
> Did the -rt guys tell the wireless guys about this?

Honestly, I don't recall hearing about it.  Ivo?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
