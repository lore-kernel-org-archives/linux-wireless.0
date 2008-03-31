Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48018 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416AbYCaScn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 14:32:43 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JgOoA-0008EL-MW
	for linux-wireless@vger.kernel.org; Mon, 31 Mar 2008 18:32:38 +0000
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 18:32:38 +0000
Received: from tobutaz+kernel by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 18:32:38 +0000
To: linux-wireless@vger.kernel.org
From: TK <tobutaz+kernel@gmail.com>
Subject: Re: 2.6.24 panic in rt2x00lib_txdone / ieee80211_tx_status_irqsafe
Date: Mon, 31 Mar 2008 18:32:30 +0000 (UTC)
Message-ID: <fsranu$qk3$1@ger.gmane.org> (sfid-20080331_193246_955285_B958E6C9)
References: <fsjfq1$vl8$1@ger.gmane.org>
	<200803282034.56042.IvDoorn@gmail.com> <fsot23$biu$1@ger.gmane.org>
	<fsou5a$biu$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 30 Mar 2008 20:45:31 +0000, TK said:

> On Sun, 30 Mar 2008 20:26:44 +0000, TK said:
> 
>> On Fri, 28 Mar 2008 20:34:55 +0100, Ivo van Doorn said:
>> 
>>> The wireless-testing would be the most interesting since several race
>>> conditions in the queues where fixed in there.

Great, I wasn't able to trigger the crash again.
I expect there is no chance of a backport though - 2.6.25 doesn't play 
nice with my distro, yet.

