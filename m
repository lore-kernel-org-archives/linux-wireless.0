Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35735 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbZADQiQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 11:38:16 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: rate instability in wireless stack
Date: Sun, 4 Jan 2009 17:36:47 +0100
Cc: linux-wireless@vger.kernel.org
References: <20090104164649.GV496@one.firstfloor.org>
In-Reply-To: <20090104164649.GV496@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901041736.47650.mb@bu3sch.de> (sfid-20090104_173822_059732_0D3AFB8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 January 2009 17:46:49 Andi Kleen wrote:
[snip]

I guess you're using the minstrel rate control.
Can you switch to PID rate control and retry.

Note that intel uses its own rate control algorithm. so I guess that's
where it breaks.

-- 
Greetings, Michael.
