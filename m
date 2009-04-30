Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63061 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759878AbZD3WlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 18:41:07 -0400
Subject: Re: mmotm 2009-04-27-15-45 uploaded - iwl3945 oops
From: reinette chatre <reinette.chatre@intel.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <24133.1241020608@turing-police.cc.vt.edu>
References: <200904272305.n3RN51mu031395@imap1.linux-foundation.org>
	 <25818.1240938876@turing-police.cc.vt.edu>
	 <1240951184.1207.11.camel@rc-desk>
	 <24133.1241020608@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 15:46:53 -0700
Message-Id: <1241131613.10498.80.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-04-29 at 08:56 -0700, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 28 Apr 2009 13:39:44 PDT, reinette chatre said:
> 
> > Could you please revert this and test again?
> > 
> > If this does not help, could you please bisect?
> 
> Same kernel that oopsed 2 nights ago failed to do so in 8 or 9 hours last
> night - so it isn't a "fire up wpa_supplicant and know inside 20 or 30 seconds
> if the kernel tested is good" candidate for bisection.  Will collect what
> info I can.

Do you perhaps still have the original logs of this problem? The log you
sent initially started with some errors. Were there perhaps any other
driver status or error messages printed before that?

Thank you

Reinette


