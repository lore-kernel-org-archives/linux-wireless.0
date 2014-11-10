Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43012 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaKJKaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 05:30:39 -0500
Received: by mail-wg0-f41.google.com with SMTP id k14so8433948wgh.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 02:30:38 -0800 (PST)
From: Uwe Brauer <oub@mat.ucm.es>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw\@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: Thinkpad X60s/200s: Intel 3945/5100 works with kernel 2.6.32-67/3.0.0-32 but not 3.7 vanilla.
References: <87d28zdplq.fsf@mat.ucm.es>
	<CANUX_P0f0WAHoq3CsC3V-jp4m3_Q7qLz7X+Mvn1hk9_JPrPTGg@mail.gmail.com>
Reply-To: Uwe Brauer <oub@mat.ucm.es>
Date: Mon, 10 Nov 2014 11:30:26 +0100
Message-ID: <87egtbxs8t.fsf@mat.ucm.es> (sfid-20141110_113043_489571_43C3C8D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


   > On Fri, Nov 7, 2014 at 4:58 PM, Uwe Brauer <oub@mat.ucm.es> wrote:

   > you problem is that you didn't compile the kernel with wireless
   > extensions. This interface is deprecated, but I don't remember if it
   > was the case for 3.7.
   > In any case, this is a problem in your config, not a driver issue.

What make you say that?
My config file concerning wireless options is:

CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_IPWIRELESS=m

These are all the options I encounter.

