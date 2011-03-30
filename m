Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54134 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab1C3PpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 11:45:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Q4xZx-0006Di-LZ
	for linux-wireless@vger.kernel.org; Wed, 30 Mar 2011 17:45:05 +0200
Received: from 193.206.22.97 ([193.206.22.97])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 17:45:05 +0200
Received: from roberto.riggio by 193.206.22.97 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 17:45:05 +0200
To: linux-wireless@vger.kernel.org
From: Roberto Riggio <roberto.riggio@create-net.org>
Subject: Re: radiotap rate no longer supported in mac80211?
Date: Wed, 30 Mar 2011 15:42:26 +0000 (UTC)
Message-ID: <loom.20110330T174020-71@post.gmane.org>
References: <AANLkTileP2BMsZUsA-NigDcmVcAmXn6KNw0R1vMzSgYw@mail.gmail.com> <1276633107.14133.11.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@...> writes:

> I posted a patch that would add rate and retry flags:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/47441
> 
> I didn't see any interest in the patch.  Perhaps injecting packets at a
> specific rate in not particularly needed.

Well maybe it is a little late to reply to this. Anyway I'm actually using
your patch as part of a custom routing protocol for a mesh based on the roofnet 
code.






