Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab2CGHiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 02:38:25 -0500
Subject: Re: Hw Accel in Secured Mesh No Longer Work
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
In-Reply-To: <CAEFj984gKDRtjP9NJYqjvWCZ=HxwW3DQ036guVY6Vbj=yx1H6g@mail.gmail.com> (sfid-20120307_024516_117354_938006F8)
References: <CAEFj984b_Aihd9hc-dMArPxZPod8eKsxzekLwO74XbTUKGX9LQ@mail.gmail.com>
	 <CAEFj984gKDRtjP9NJYqjvWCZ=HxwW3DQ036guVY6Vbj=yx1H6g@mail.gmail.com>
	 (sfid-20120307_024516_117354_938006F8)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Mar 2012 08:38:22 +0100
Message-ID: <1331105902.3519.2.camel@jlt3.sipsolutions.net> (sfid-20120307_083828_145295_5E2090BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-07 at 09:44 +0800, Yeoh Chun-Yeow wrote:
> Hi, Johannes
> 
> 
> Hardware acceleration is found to not working for secured mesh
> (802.11s) anymore after the introduction of this patch.
> http://www.spinics.net/lists/linux-wireless/msg83644.html
> 
> 
> Key installation is not possible for station not uploaded. Thus, to
> achieve HT for secured mesh is not possible. Revert to the old key.c
> solves the problem.

Huh? Well that's odd, maybe there's a race condition and you program the
key before the peer was added to the device?

What device are you working with?

johannes


