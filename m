Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:3290 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYDSTbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 15:31:40 -0400
Received: by wa-out-1112.google.com with SMTP id m16so1822471waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 19 Apr 2008 12:31:39 -0700 (PDT)
Subject: Re: [patch 6/7] mac80211: michael.c use unaligned/byteorder helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: akpm@linux-foundation.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, jbenc@suse.cz
In-Reply-To: <480A38FA.3090300@lwfinger.net>
References: <200804182059.m3IKxqcu015604@imap1.linux-foundation.org>
	 <480A38FA.3090300@lwfinger.net>
Content-Type: text/plain
Date: Sat, 19 Apr 2008 12:31:56 -0700
Message-Id: <1208633516.7941.1.camel@brick> (sfid-20080419_203144_399103_9826D127)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-04-19 at 13:24 -0500, Larry Finger wrote:
> akpm@linux-foundation.org wrote:
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > Rather than open-coding the get/put of little endian values, use
> > get/put_unaligned and the byteorder helpers.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > Cc: Jiri Benc <jbenc@suse.cz>
> > Cc: John W. Linville <linville@tuxdriver.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> 
> The set of 7 patches break my system, which is x86_64 using WPA-PSK 
> TKIP. If I back out #6 and 7, then all is OK.
> 
> Does this series have any prerequisites? I'm running the current 
> wireless-testing git tree.
> 

Thanks for the testing, I posted an updated patchset on Thursday
last week and this set has been dropped from -mm.

The new patchset depends on the new unaligned helpers in -mm,
if you want I can send you a full set if you feel like testing
them.

Harvey


