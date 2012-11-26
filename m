Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49078 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab2KZThD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 14:37:03 -0500
Date: Mon, 26 Nov 2012 13:36:55 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Daniel Wagner <wagi@monom.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded debug/trace
 support
Message-ID: <20121126193655.GF4556@thinkpad-t410> (sfid-20121126_203707_946366_746017CB)
References: <50AA845C.2050809@monom.org>
 <50AB3182.5040505@monom.org>
 <20121120142822.GA26602@thinkpad-t410>
 <50ABC168.8080904@monom.org>
 <20121120205418.GB26602@thinkpad-t410>
 <50AC05A5.3090706@monom.org>
 <50AC07F2.8000400@monom.org>
 <50ACA28F.9010800@broadcom.com>
 <50ACA55F.5050406@monom.org>
 <20121121143528.GC23606@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121121143528.GC23606@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 21, 2012 at 08:35:28AM -0600, Seth Forshee wrote:
> > My 'test' setup is following: I downloaded a larger file and let a youtube 
> > video play. With tracing enabled the download and the playback did work nicely.
> > 
> > Without tracing enabled playing back only a youtube video was 'triggering' 
> > the problem. It downloads a few seconds of content in a burst and then the playback
> > starts. Under normal conditions, the app will continue downloading the video at a 
> > lower rate. But this normally doesn't happen right now. Often it will just stop
> > working and often the connection is completely blocked, e.g. pinging a host
> > wont work.
> 
> I'll see if I can reproduce, but if it's specific to the AP then I may
> not have any luck. Don't expect to hear much from me until next week
> though; I'm on holiday starting today and will be visiting family.

It seems I'm unable to reproduce the problem with any of the APs
available to me, unfortunately.

Seth

