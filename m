Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59715 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab2LTM61 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 07:58:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Tlfhp-0002li-6R
	for linux-wireless@vger.kernel.org; Thu, 20 Dec 2012 13:58:33 +0100
Received: from aslw039181.ethz.ch ([129.132.39.181])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2012 13:58:33 +0100
Received: from dantard by aslw039181.ethz.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2012 13:58:33 +0100
To: linux-wireless@vger.kernel.org
From: Danilo <dantard@unizar.es>
Subject: Re: Incoherency in iw (or mac80211 or drivers) behavior -- possible BUG in iwl4965
Date: Thu, 20 Dec 2012 12:58:05 +0000 (UTC)
Message-ID: <loom.20121220T135530-191@post.gmane.org> (sfid-20121220_135830_604602_407381DF)
References: <loom.20121219T172801-213@post.gmane.org> <loom.20121220T112036-707@post.gmane.org> <CA+XFjir7D5eCMrS+4FTDJdon3RZh4UXRmgzJY7NmRS3Z6RZetg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik <netrolller.3d@...> writes:


> 
> IIRC iwl4965 uses its own rate control algorithm (a while ago, it was
> called "iwl-agn-rs", before the iwlegacy split). I think you should
> look for the problem there.
> 

Thanks for the answer.
In fact I looked at it as well and I tried to force iwl4965 to use 'minstrel' or 
'pid' algorithm hacking the code of the mac80211 with scarce success.
Do you know what is the correct way of selecting the desire rate control 
algorithm?

Thanks again.




