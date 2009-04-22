Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([207.115.11.55]:38359 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZDVSXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 14:23:45 -0400
Message-ID: <49EF609A.9070609@lwfinger.net> (sfid-20090422_202349_253927_E6D2994D)
Date: Wed, 22 Apr 2009 13:23:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
Subject: Re: patch staging-rtl8187se-fix-compilation-warnings-and-procfs-directory-leak.patch
 added to gregkh-2.6 tree
References: <1240421701553@kroah.org>
In-Reply-To: <1240421701553@kroah.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

gregkh@suse.de wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     Subject: Staging: rtl8187se: Fix compilation warnings and procfs directory leak
> 
> to my gregkh-2.6 tree.  Its filename is
> 
>     staging-rtl8187se-fix-compilation-warnings-and-procfs-directory-leak.patch
> 
> This tree can be found at 
>     http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/

Just to let you know, Bernhard Schiffner has reported using this driver for an
8-hour stretch with numerous downloads, etc. with no hiccups. Actually, he was
using a stripped-down version with about 4000 lines of dead code removed. That
is my starting point for the mainline driver.

Larry
