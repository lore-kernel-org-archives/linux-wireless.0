Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:4842 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763867AbZANRUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 12:20:23 -0500
Message-ID: <496E1ED3.20500@canonical.com> (sfid-20090114_182028_606589_53C018BA)
Date: Wed, 14 Jan 2009 10:20:19 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb updated 2009-01-14
References: <20090114162250.GC3854@tuxdriver.com>
In-Reply-To: <20090114162250.GC3854@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> FYI...wireless-regdb.git has been updated with the recent patches
> from Michael, Luis, and Pavel.  In particular the Makefile is much
> better than I had previously left it. :-)
> 
> It is about time (or past time) that we start pushing distributions to
> pick-up CRDA and either their own version of wireless-regdb or just
> pull the version I am publishing.  I think our wireless regulatory
> compliance mechanisms are a lot more flexible than what other systems
> are offering -- it is time to get it into the hands of users and get
> userland apps (e.g. NetworkManager) to take advantage of it.
> 
> Thanks,
> 
> John

Workin' on it... My intent is to have CRDA/REGDB packaged and ready in
time for Jaunty (April '09). I'm just getting started this week.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
