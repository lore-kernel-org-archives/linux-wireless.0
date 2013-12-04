Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46732 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab3LDILx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 03:11:53 -0500
Message-ID: <1386144708.4284.1.camel@jlt4.sipsolutions.net> (sfid-20131204_091158_653127_5798919B)
Subject: Re: [PATCH] nl80211: allow the use of DFS channel in mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Date: Wed, 04 Dec 2013 09:11:48 +0100
In-Reply-To: <CAEFj984xLXHCLoXUrevEdaeFyC1qGq5T9Zt9MPf5kYj7WZUNCA@mail.gmail.com> (sfid-20131204_022624_630701_2B3B2F16)
References: <1385971550-4892-1-git-send-email-yeohchunyeow@gmail.com>
	 <1386075017.4393.11.camel@jlt4.sipsolutions.net>
	 <CAEFj984xLXHCLoXUrevEdaeFyC1qGq5T9Zt9MPf5kYj7WZUNCA@mail.gmail.com>
	 (sfid-20131204_022624_630701_2B3B2F16)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-04 at 09:26 +0800, Yeoh Chun-Yeow wrote:
> > This seems pretty pointless right now? There's nothing supporting it, is
> > there?
> >
> I have currently extended the iw to trigger the CAC on DFC channel
> using NL80211_CMD_RADAR_DETECT. But not able to join mesh on DFS even
> it is clear.
> 
> So this patch at least allows us to trigger beaconing and bring up the
> mesh on DFS channel.

Yeah, never mind. I was confused about the "TODO DFS" in the mesh code,
but that's with CSA *to* a radar channel.

I'll apply this.

johannes

