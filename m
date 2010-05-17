Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21289 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab0EQTKm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 15:10:42 -0400
Subject: Re: A file to print the release of loaded compat-wireless stuff
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTilrjw-Jq4MEQPT35fHTTqsaSdU5Jc7lt_2lUH2V@mail.gmail.com>
References: <x2q43e72e891005041344gb9945d73p3d97e648fd13aa85@mail.gmail.com>
	 <1273007509.12618.1.camel@mj>
	 <z2o43e72e891005041451qa4ea338bu5a20171a82f13471@mail.gmail.com>
	 <AANLkTilrjw-Jq4MEQPT35fHTTqsaSdU5Jc7lt_2lUH2V@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 17 May 2010 15:10:39 -0400
Message-Id: <1274123439.4743.15.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-17 at 10:54 -0700, Luis R. Rodriguez wrote:

> Oh wow, and look at that, even if you enable the module as built-in to
> the kernel you still get the module parameter sysfs file for it. For
> example I just built-in cfg80211 on my kernel and I still see the
> ieee80211_regdom module parameter:
> 
> mcgrof@tux ~ $ lsmod | grep cfg
> mcgrof@tux ~ $ cat /sys/module/cfg80211/parameters/ieee80211_regdom
> 00
> 
> This is important as some distributions [1] might built-in some stable
> compat-wireless releases into their older kernel releases.

I actually wanted to mention that, but decided that it's irrelevant to
compat-wireless.  It turns out I should have.

-- 
Regards,
Pavel Roskin
