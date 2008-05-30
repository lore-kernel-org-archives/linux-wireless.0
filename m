Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38907 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYE3OGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 10:06:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: suspend vs. b43
Date: Fri, 30 May 2008 16:06:25 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1212150713.4117.2.camel@johannes.berg>
In-Reply-To: <1212150713.4117.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805301606.25556.mb@bu3sch.de> (sfid-20080530_160653_852704_A8E8F674)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 30 May 2008 14:31:53 Johannes Berg wrote:
> Since a while ago I've had trouble resuming when b43 was connected to an
> AP while suspended.
> 
> I did a test today where this was the only difference, but I failed to
> see whether ssb or b43 were causing the problem.
> 
> Does anyone have a machine with b43 in it that can suspend and supports
> the RTC-trace feature so we can narrow it down? Even reproducing might
> help to make sure it's not just something weird with my powerbook.

Resume is pretty broken since some time for me.
It sometimes works fine and sometimes just hangs with a black screen.
I have no idea what's going on.

-- 
Greetings Michael.
