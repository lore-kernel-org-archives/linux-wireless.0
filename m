Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:24054 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYE3OtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 10:49:24 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: suspend vs. b43
Date: Fri, 30 May 2008 16:49:14 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de
References: <1212150713.4117.2.camel@johannes.berg> <200805301606.25556.mb@bu3sch.de> <1212158238.4117.4.camel@johannes.berg>
In-Reply-To: <1212158238.4117.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805301649.14445.hs4233@mail.mn-solutions.de> (sfid-20080530_164926_727854_C337BDA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Odd. Resume itself works just fine here, except when b43 is
> up. But then again, you might not notice that this is the
> problem because by default, nothing gets printed on the resume
> console and then it will indeed hang with a black screen.

pepper it with printk's and add netconsole ...
