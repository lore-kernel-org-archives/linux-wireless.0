Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from namei.org ([69.55.235.186]:60203 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758173AbXIXXbS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 19:31:18 -0400
Date: Mon, 24 Sep 2007 16:31:02 -0700 (PDT)
From: James Morris <jmorris@namei.org>
To: Michal Schmidt <mschmidt@redhat.com>
cc: linux-wireless@vger.kernel.org, fabrice@bellet.info
Subject: Re: Problem with Cisco MPI350/airo
In-Reply-To: <46F7A0F2.7000900@redhat.com>
Message-ID: <Xine.LNX.4.64.0709241630130.6592@us.intercode.com.au>
References: <Xine.LNX.4.64.0709190051080.29334@us.intercode.com.au>
 <46F7A0F2.7000900@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 24 Sep 2007, Michal Schmidt wrote:

> Mine doesn't do that. Can you try replacing airo.c with the version from
> 2.6.22 ?
> git-checkout v2.6.22 drivers/net/wireless/airo.c
> 
> Does it make it work correctly again?

Nope.  I'll try a bisect when I get the chance.



-- 
James Morris
<jmorris@namei.org>
