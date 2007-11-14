Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:41994 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbXKNPUR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 10:20:17 -0500
Received: from rufsun5.fkie.fgan.de ([128.7.2.5] helo=mailhost.fgan.de)
	by mailguard.fgan.de with esmtp (Exim 4.63)
	(envelope-from <Rogge@fgan.de>)
	id 1IsK2K-0002lJ-GX
	for linux-wireless@vger.kernel.org; Wed, 14 Nov 2007 16:20:16 +0100
Received: from mailserv.lorien.fkie.fgan.de ([128.7.90.101])
	by mailhost.fgan.de with esmtp (Exim 4.67 #7 (Solaris MB))
	id 1IsK2K-00079M-Bm
	for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 16:20:16 +0100
From: Henning Rogge <rogge@fgan.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Virtual wireless network card for mac80211
Date: Wed, 14 Nov 2007 16:20:15 +0100
References: <200711141316.50393.rogge@fgan.de> <20071114150839.GA6226@tuxdriver.com>
In-Reply-To: <20071114150839.GA6226@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711141620.15821.rogge@fgan.de> (sfid-20071114_152034_284604_E26978DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 14 November 2007 16:08:39 schrieben Sie:
> On Wed, Nov 14, 2007 at 01:16:50PM +0100, Henning Rogge wrote:
> No, but I have been thinking about this as well.  It might be a nice
> capability to have, so long as the regulatory spectre continues to
> discourage some vendors from disclosing information about their
> hardware.  At least such a scenario seems less grey w.r.t. GPL
> compliance.
>
> Still, I would not want to put much effort into a project that
> distracts from development of fully open source drivers.  But I think
> the performance of such a solution would be sub-optimal enough to
> discourage full reliance upon it.  And the plus of having a userland
> binary driver versus no driver at all might make it worthwhile.
>
> What is the situation that makes this interesting to you?
I'm not interested in having a binary driver but in simulation of mobile 
networks with virtual machines. By placing a virtual driver into the mac80211 
layer the sollution would be totally transparent for the clients, even for 
applications with Radiotap headers and Libpcap.
A central server would be connected to the userspace parts of the virtual 
driver and simulate connections between the VMs.

Henning Rogge

