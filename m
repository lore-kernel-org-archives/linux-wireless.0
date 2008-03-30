Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43490 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbYC3Upl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2008 16:45:41 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Jg4PK-000147-UJ
	for linux-wireless@vger.kernel.org; Sun, 30 Mar 2008 20:45:38 +0000
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 30 Mar 2008 20:45:38 +0000
Received: from tobutaz+kernel by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 30 Mar 2008 20:45:38 +0000
To: linux-wireless@vger.kernel.org
From: TK <tobutaz+kernel@gmail.com>
Subject: Re: 2.6.24 panic in rt2x00lib_txdone / ieee80211_tx_status_irqsafe
Date: Sun, 30 Mar 2008 20:45:31 +0000 (UTC)
Message-ID: <fsou5a$biu$2@ger.gmane.org> (sfid-20080330_214545_217556_05A8546F)
References: <fsjfq1$vl8$1@ger.gmane.org>
	<200803282034.56042.IvDoorn@gmail.com> <fsot23$biu$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 30 Mar 2008 20:26:44 +0000, TK said:

> On Fri, 28 Mar 2008 20:34:55 +0100, Ivo van Doorn said:
> 
>> Hi,
>> 
>> Could you try rt2x00 2.0.14 (2.6.25-rc*) or a wireless-testing kernel
>> to see if the problems persist?
>> The wireless-testing would be the most interesting since several race
>> conditions in the queues where fixed in there.
> 
> I've had no luck with either:
> rt2x00 2.0.14 - 93d2334f3773c0d4e8dfafdb394f73bb1bdf0cc9 or a recent
> wireless-testing - 78f8e644105878c3e13ca281529c3c9e661bf59f

I see there is a fix for the second, I'll try it sometime.


