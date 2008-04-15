Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53242 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbYDONWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 09:22:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Dad <ccmcphe@verizon.net>
Subject: Re: mac80211 question
Date: Tue, 15 Apr 2008 15:21:33 +0200
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <48037A8E.5050200@verizon.net> <1208188488.31015.34.camel@localhost.localdomain> <4804A9F7.1030507@verizon.net>
In-Reply-To: <4804A9F7.1030507@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804151521.33963.mb@bu3sch.de> (sfid-20080415_142217_102386_906E4519)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 April 2008 15:13:27 Dad wrote:
> Our tech support people use it - to distinguish which wireless is for 
> which work group.
> You see, we have servers with multiple wireless's and depending on the 
> work group and
> location, the nickname aids the tech support people to identify what 
> wireless a person is
> using. That is the only reason why we use it. Right now I have created 
> code for those IOCTL's,
> so if mac80211 doesn't have it, we can just implement it on our servers.

Why don't you do that wireless-interface to whatever mapping in userspace?


-- 
Greetings Michael.
