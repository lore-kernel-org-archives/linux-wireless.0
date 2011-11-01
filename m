Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab1KAWIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 18:08:50 -0400
Date: Tue, 1 Nov 2011 18:08:45 -0400
From: Dave Jones <davej@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.1+ iwlwifi lockup
Message-ID: <20111101220845.GA16080@redhat.com> (sfid-20111101_230907_277893_3ED0A890)
References: <20111031143408.GA17152@redhat.com>
 <1320179254.31823.130.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1320179254.31823.130.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 01, 2011 at 01:27:34PM -0700, Guy, Wey-Yi wrote:
 > Dave,
 > 
 > On Mon, 2011-10-31 at 07:34 -0700, Dave Jones wrote:
 > > I just got this trace, and a driver lockup that caused me to have to
 > > unload & reload the iwlwifi module to get networking back.
 > > hardware is..
 > > 04:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300
 > > 
 > > This is new as of 3.1+  (This kernel was Linus' tree as of last night)
 > > 
 > >         
 > 
 > Any more information to help us understand how to re-produce the issue?
 > without more data, it is really hard to root cause and fix it.
 > 
 > Thanks
 > Wey

Wasn't doing anything special.  ssh, firefox, git clones.

	Dave

