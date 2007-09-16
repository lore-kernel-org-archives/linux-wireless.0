Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:1074 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbXIQM41 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 08:56:27 -0400
Date: Sun, 16 Sep 2007 19:16:42 +0200
From: maximilian attems <max@stro.at>
To: Tomas Winkler <tomasw@gmail.com>
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: iwlwifi testing
Message-ID: <20070916171642.GB5280@stro.at>
References: <20070909165447.GA2574@stro.at> <1ba2fa240709091000o3fecdcd4t301d715d864a1d95@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240709091000o3fecdcd4t301d715d864a1d95@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 09 Sep 2007, Tomas Winkler wrote:

> > * oops on rmmod (didn't take down an interface before)
> http://intellinuxwireless.org/repos/?p=iwlwifi.git;a=commit;h=0c4826cdf9adbda1af908aa5fec22ac2277f2e53

fixed thanks, another bugger:
iwconfig wlan0 mode monitor
 Error for wireless request "Set Mode" (8B06) :
     SET failed on device wlan0 ; Device or resource busy.

-- 
maks
