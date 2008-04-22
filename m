Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:52603 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYDVEaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 00:30:10 -0400
Received: by wa-out-1112.google.com with SMTP id m16so3601398waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 21:30:10 -0700 (PDT)
Message-ID: <ed10ee420804212130r59833142lc031afe49107123d@mail.gmail.com> (sfid-20080422_063100_441761_A8274CC3)
Date: Mon, 21 Apr 2008 21:30:09 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] iwlwifi 3945 debug parameter should be writable via sysfs
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <1ba2fa240804211451o1c7eb062q3ae292c06ed11406@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <ed10ee420804210010g228aa4b7j9383e5417b7dcb8c@mail.gmail.com>
	 <1ba2fa240804211451o1c7eb062q3ae292c06ed11406@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/21/08, Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Apr 21, 2008 at 10:10 AM, SL Baur <steve@xemacs.org> wrote:
>  > Is there any reason why the debug parameter in the iwlwifi driver
>  >  should be read-only?

> it doesn't have any affect on debug output though.  This variable is
>  copied to to another one in pci proble
>  so unless you have 2 cards there is no use for it.
>  Run time debug output can be handled through debug_level sysfs entry
>  /sys/bus/pci/drivers/iwl4965/debug_level
>  Yet this will be changed as well to be per device instead of per driver

O.K.  The driver help recommended turning on debug for first time usage
and I was surprised when I didn't get any debug output.  And I see now
that /proc/bus/pci/drivers/iwl3945/debug_level *is* writable.  I'm lost in a
twisty maze of /sys directories, all subtlely different.

The driver itself works fine, but I'm having trouble getting decent speed out
of it, similar to the horrible performance I had under another operating
system, not quite as bad but still worse than a MacBook Pro.  Any clues on what
I can look for to see why it so relatively slow?  I'm going to put it to the WoW
test as soon as I can get a modern userland & Wine on the machine, it's running
RHEL 4 now.  The machine is a Lenovo T60.

-sb
