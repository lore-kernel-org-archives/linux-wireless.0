Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2773 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYBAQCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 11:02:11 -0500
Date: Fri, 1 Feb 2008 10:49:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Mansfield <david@cobite.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: repeatable rmmod/ksofitirqd hang with rtl8187
Message-ID: <20080201154945.GA3050@tuxdriver.com> (sfid-20080201_160219_987888_E454B009)
References: <1201878685.18907.54.camel@gandalf.cobite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1201878685.18907.54.camel@gandalf.cobite.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 01, 2008 at 10:11:25AM -0500, David Mansfield wrote:
> Hi, 
> 
> I'm trying to use the rtl8187 in the Fedora 8 kernel 2.6.23.14-107.fc8
> on x86_64 and I'm having a number of problems with reliability.
> However, the most obvious problem is that the module cannot be removed.
> 
> Attempting to rmmod the rtl8187 causes rmmod and ksoftirqd to go to 100%
> every time.

I don't see anything in the posted information which clearly
suggests an rtl8187 problem or even a mac80211 one.  Would you mind
opening a bugat bugzilla.redhat.com for this issue?  Please add
"linville@redhat.com" to the CC: field when you open it.

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
