Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:36747 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab0LPKrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 05:47:25 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PTBMq-0002nj-NA
	for linux-wireless@vger.kernel.org; Thu, 16 Dec 2010 11:47:24 +0100
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:47:24 +0100
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:47:24 +0100
To: linux-wireless@vger.kernel.org
From: jpo234 <pommnitz@yahoo.com>
Subject: Re: Netlink Memory Leak Issue
Date: Thu, 16 Dec 2010 10:47:10 +0000 (UTC)
Message-ID: <loom.20101216T114053-656@post.gmane.org>
References: <B659B0EE7F1D5A499E4A4BEB0BECBA2518292B3D21@GUREXMB01.ASIAN.AD.ARICENT.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Saurabh8 Jain <saurabh8.jain@...> writes:
> Where is this memory getting free? Do I need to free this memory?
> 
> When I executed iw commands to set few values in loop.  I saw there is drop in
free memory of "top" command. I am
> working on compatwireless-2010-06-27.

Do you really think that a perceived memory leak in libnl could explain this?
This can't be true. If you run iw in a shell loop it will terminate after every
invocation and the kernel will free all associated resources.

Regards
  Joerg

