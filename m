Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:35888 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752611AbXLWDSl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 22:18:41 -0500
Date: Sun, 23 Dec 2007 04:17:39 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: ssnt2@eng.cam.ac.uk
Cc: linux-wireless@vger.kernel.org
Subject: Re: B43 not working
Message-ID: <20071223041739.1f9e82cb@morte> (sfid-20071223_031845_289038_345D42C9)
In-Reply-To: <200712230117.35920.ssnt2@eng.cam.ac.uk>
References: <200712230117.35920.ssnt2@eng.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 23 Dec 2007 01:17:35 +0000
Shawn Tan <ssnt2@eng.cam.ac.uk> wrote:
 
> 30:00.0 0280: 14e4:4312 (rev 02)

You need a wireless-2.6 tree including this commit:
commit ef63d02426e1f0157e049240c2be87c92e64afa1
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Mon Nov 26 10:29:47 2007 -0600

You can just grab the tree/branch John suggested, or, in case you don't
want to mess with git and a complete kernel rebuild, please see:
http://linuxwireless.org/en/users/Download


-- 
Ciao
Stefano
