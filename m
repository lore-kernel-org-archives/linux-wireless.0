Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.230]:15164 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbXCEAqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 19:46:38 -0500
Received: by wr-out-0506.google.com with SMTP id 37so1174726wra
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2007 16:46:37 -0800 (PST)
Message-ID: <5640c7e00703041646w32d7bc77s33d1fca4755a1b78@mail.gmail.com>
Date: Mon, 5 Mar 2007 13:46:36 +1300
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: Recent wireless breakage (ipw2200, iwconfig, NetworkManager)
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
	linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
In-Reply-To: <20070305002550.GI23311@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070304220857.GH23311@waste.org>
	 <1173051564.6131.13.camel@johannes.berg>
	 <20070305002550.GI23311@waste.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/5/07, Matt Mackall <mpm@selenic.com> wrote:
> > This is due to the recent sysfs restructuring I think. IIRC the fix is
> > to upgrade hal to a current git version.
>
> If that's the cause, the fix is to back out whatever was done to break
> userspace. Breaking userspace is not ok. Upgrading from 2.6.x to
> 2.6.x+1 should not entail replacing substantial parts of userspace,
> especially with NOT-EVEN-FRAKKING-RELEASED-YET CODE.
>
> I will try a new HAL when it shows up in Debian/unstable and not a
> moment sooner.
>
But you're running a kernel that's not in Debian/unstable so this
seems a bit hypocritical.

When you work with bleeding edge kernels you have to be prepared to
work around things. Hell for ages git wasn't in Debian - unstable
even, udev would break things etc.

Just my 2c worth.
-- 
Web: http://wand.net.nz/~iam4
Blog: http://iansblog.jandi.co.nz
WAND Network Research Group
