Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab2BHKwY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 05:52:24 -0500
Date: Wed, 8 Feb 2012 11:52:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/4] iwlwifi: dump stack when fail to gain access to the
 device
Message-ID: <20120208105220.GA2283@redhat.com> (sfid-20120208_115228_427924_B85952AD)
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
 <1328544496.14547.10.camel@wwguy-ubuntu>
 <20120207080122.GA2246@redhat.com>
 <1328624472.7290.51.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1328624472.7290.51.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > I agree the message and check make sense, but not sure what new clue we
> > > got by doing this?
> > 
> > Calltrace with very first grab nic access failure.
> > 
> Good point, we have this "PCI bus disappear" problem on all of our
> devices and very difficult to debug.
> 
> btw, do you have any system can reproduce this problem? we have nothing.

No, those problems are not reproducible here as well.

Stanislaw
