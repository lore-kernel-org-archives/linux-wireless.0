Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mi1.bluebottle.com ([206.188.25.14]:44456 "EHLO
	mi1.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXHAGk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 02:40:58 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by mi1.bluebottle.com (8.13.1/8.13.1) with ESMTP id l716evvW009219
	for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 23:40:57 -0700
Message-Id: <200708010640.l716evvW009219@mi1.bluebottle.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Axj <axjslack@bluebottle.com>, Pavel Roskin <proski@gnu.org>,
	linux-wireless@vger.kernel.org
Date: Tue, 31 Jul 2007 23:40:57 -0700
From: Axj <axjslack@bluebottle.com>
Subject: Re: Request for help...
References: <1185289332.46a61474a444c@mail.bluebottle.com>  <1185355931.3131.13.camel@debian.sh.intel.com>  <200707261511.l6QFB2jK015121@mi0.bluebottle.com>  <1185466954.14557.5.camel@dv>  <200707270634.l6R6Yh2j003295@mi1.bluebottle.com>  <1185522251.3079.66.camel@debian.sh.intel.com>  <200707270848.l6R8mqkh004526@mi1.bluebottle.com>  <1185526612.3079.75.camel@debian.sh.intel.com>  <200707270910.l6R9AssD005317@mi0.bluebottle.com> <1185757127.3079.101.camel@debian.sh.intel.com>
In-Reply-To: <1185757127.3079.101.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Zhu Yi <yi.zhu@intel.com>:

> On Fri, 2007-07-27 at 02:10 -0700, Axj wrote:
> > iwconfig wlan0 essid "lago" mode Ad-Hoc 
> > and then give me error.... 
> 
> What's the error?
> 
> -yi
> 

When I try the command 
 iwconfig wlan0 essid "lago" mode Ad-Hoc 

show me 

Error for wireless request Set Mode (8B06) :
    SET failed on device wlan0 ; Device or resource busy.

But if I connect with for example 

iwconfig wlan0 essid "dip-open" #my university wireless connection it works, and very well.

For this I have no explanation

----------------------------------------------------------------------
Free pop3 email with a spam filter.
http://www.bluebottle.com/tag/5

