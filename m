Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43238 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbXLLAYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 19:24:23 -0500
From: Michael Buesch <mb@bu3sch.de>
To: doug@nostar.net
Subject: Re: Problems with b43 using BCM4306 r3
Date: Wed, 12 Dec 2007 01:22:31 +0100
Cc: linux-wireless@vger.kernel.org
References: <475DA27F.2040004@nostar.net> <200712102258.29802.mb@bu3sch.de> <50633.68.40.216.125.1197418099.squirrel@webmail.nostar.net>
In-Reply-To: <50633.68.40.216.125.1197418099.squirrel@webmail.nostar.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712120122.32119.mb@bu3sch.de> (sfid-20071212_002434_589935_E6B8CFFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 December 2007 01:08:19 doug@nostar.net wrote:
> The problems only exist on the planet CCRMA
> 
> http://ccrma.stanford.edu/planetccrma/software/
> 
> low-lat patched kernel that I was using.  I'm now running a stock Fedora 
> 8 2.6.23.8-63.fc8 kernel and there dont appear to be anymore wifi 
> problems.  My reasons for using the ccrma kernel werent low latency 
> performance so much as a working firewire stack (fedora 7 and above uses 
> a new, broken stack) but I found another method.

Ah, well. The driver is not supposed to work with this kind of stuff.

-- 
Greetings Michael.
