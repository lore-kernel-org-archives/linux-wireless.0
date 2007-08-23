Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49398 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbXHWJMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 05:12:16 -0400
Subject: Re: ALERT: firmware change for b43
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46C89BF1.5060306@lwfinger.net>
References: <46C89BF1.5060306@lwfinger.net>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 10:12:10 +0100
Message-Id: <1187860330.22432.139.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-08-19 at 14:37 -0500, Larry Finger wrote:
> It is recommended that you update fwcutter before these patches are
> merged. If your version of fwcutter was obtained with subversion, a
> simple 'svn update' in the fwcutter directory will suffice.
> If you are using a version provided by your distro, you will need to
> checkout the latest version with the command 'svn checkout
> svn://svn.berlios.de/bcm43xx/trunk/fwcutter'. 

Ew, Subversion. Hasn't everyone abandoned that yet?

I've set up a script to mirror it into git hourly:
	http://git.infradead.org/?p=b43-fwcutter.git
	git://git.infradead.org/b43-fwcutter.git

-- 
dwmw2

