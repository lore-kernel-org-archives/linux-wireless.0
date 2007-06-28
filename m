Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbXF1FCK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2007 01:02:10 -0400
Subject: Re: [PATCH 0/4] airo fixes
From: Dan Williams <dcbw@redhat.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Matteo Croce <rootkit85@yahoo.it>
In-Reply-To: <4682D323.2010605@redhat.com>
References: <4682D323.2010605@redhat.com>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 01:06:21 -0400
Message-Id: <1183007181.3893.18.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-06-27 at 23:14 +0200, Michal Schmidt wrote:
> Hello,
> 
> this is a series of four patches for the airo driver:
> 
> 1/4: airo: don't use the interface name so much before registration
> 2/4: airo: delay parts of initialization until the netdev is up
> 3/4: airo: disable the PCI device when unloading module
> 4/4: airo: start with radio off
> 
> The first two fix the race condition Matteo Croce was experiencing.
> The third one fixes a bug I noticed during testing.
> The last one saves some power when the card is not used.

These all look good to me, I might be able to find some time to
runtime-test them too if you want more testing.

Dan


