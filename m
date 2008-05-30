Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:42998 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbYE3Omb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 10:42:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: suspend vs. b43
Date: Fri, 30 May 2008 16:42:05 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1212150713.4117.2.camel@johannes.berg> <200805301606.25556.mb@bu3sch.de> <1212158238.4117.4.camel@johannes.berg>
In-Reply-To: <1212158238.4117.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805301642.05248.mb@bu3sch.de> (sfid-20080530_164234_617440_D94C9B2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 30 May 2008 16:37:18 Johannes Berg wrote:
> Odd. Resume itself works just fine here, except when b43 is up. But then
> again, you might not notice that this is the problem because by default,
> nothing gets printed on the resume console and then it will indeed hang
> with a black screen.

How can I change the printing?

-- 
Greetings Michael.
