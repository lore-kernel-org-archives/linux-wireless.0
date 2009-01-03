Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8400 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987AbZACAtF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 19:49:05 -0500
Subject: RE: Error compiling.    Please help
From: Pavel Roskin <proski@gnu.org>
To: tduckett <duck@tdux.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <000001c96d2e$f348af80$0200f00a@video1>
References: <000001c96d2e$f348af80$0200f00a@video1>
Content-Type: text/plain
Date: Fri, 02 Jan 2009 19:48:58 -0500
Message-Id: <1230943738.16858.0.camel@dv> (sfid-20090103_014915_004325_6EAE0802)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-02 at 18:07 -0500, tduckett wrote:
> (How about now)  I never seem to be able to get things compiled  This is
> what I get when I run make.  What do I need to do to get this to work?
> 
> 
> 
> [root@router1 madwifi-0.9.4]# make
> Checking requirements... ok.
> Checking kernel configuration... ok.
> make -C /lib/modules/2.6.27.5-41.fc9.i686/build SUBDIRS=/tmp/t/madwifi-0.9.4

linux-wireless@vger.kernel.org doesn't deal with non-free software.

-- 
Regards,
Pavel Roskin
