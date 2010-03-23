Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34243 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab0CWPuv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 11:50:51 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Nu6NO-0003sJ-E4
	for linux-wireless@vger.kernel.org; Tue, 23 Mar 2010 16:50:44 +0100
Received: from studpool-lan62.fbi.h-da.de ([141.100.40.62])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 16:50:42 +0100
Received: from m1kes by studpool-lan62.fbi.h-da.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 16:50:42 +0100
To: linux-wireless@vger.kernel.org
From: Michael Stahn <m1kes@web.de>
Subject: Re: [Proposal]TX flags
Date: Tue, 23 Mar 2010 15:50:31 +0000 (UTC)
Message-ID: <loom.20100323T162144-640@post.gmane.org>
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com> <loom.20100322T194108-874@post.gmane.org> <201003230942.15718.br1@einfach.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> similar to this we would also need to be able to specify that the beacon TSF 
> should not be overwritten. maybe a general flag like "do not change" would do?
 

Is TSF really overwritten at manual injection from userspace?
Yes such a flag would be handy, the question is: is there a
need for controlling every individual TX-option (min 3 with
Sequence, Duration and TSF). If not this would be a good
solution and easy to implement. Are there any other things
which are commonly changed?

