Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([91.250.116.113]:35660 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbBQWJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 17:09:12 -0500
Message-ID: <54E3BA37.4070009@einfach.org> (sfid-20150217_230917_638755_A5DAF69F)
Date: Tue, 17 Feb 2015 22:01:27 +0000
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: Mark Gannon <mark@truenorth.nu>, linux-wireless@vger.kernel.org
Subject: Re: Proper Method for Accessing Radiotap Functionality
References: <1700680.ayfkHzEjcQ@scooby>
In-Reply-To: <1700680.ayfkHzEjcQ@scooby>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2015 09:32 PM, Mark Gannon wrote:
> 
> Since I'm new to this domain, let me start by thanking you for your patience.
> 
> I've noticed that libpcap based  packet injection software (packetspammer and 
> reaver) are transmitting packets twice with different radiotap headers between 
> the original and the duplicate on my box (ath9k).  In order to troubleshoot, 
> I'd like to improve control over the  radiotap headers.   Packetspammer 
> includes its own version of the relevant files (e.g ieee80211_radiotap.h) and 
> reaver does the least possible.  While the relevant header files are included 
> with the kernel, they aren't in the linux-headers package on Gentoo or 
> included anywhere under /usr/include.   I do have nl80211.h file that will let 
> me query settings, but doesn't understand anything about radiotap.  
> 
> What is the proper way to include querying and generating radiotap headers?

http://git.sipsolutions.net/?p=radiotap.git

http://www.radiotap.org/

bruno
