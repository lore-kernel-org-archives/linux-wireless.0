Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45008 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096AbaIEL5S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 07:57:18 -0400
Message-ID: <1409918235.14663.3.camel@jlt4.sipsolutions.net> (sfid-20140905_135720_347121_90A22937)
Subject: Re: [PATCH v2 0/2] Add cfg80211_ops for querying the mesh proxy
 path table
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Fri, 05 Sep 2014 13:57:15 +0200
In-Reply-To: <2453987.UPN20YN3D3@rogge-hp-probook-6470b> (sfid-20140905_133954_324283_AB82E2CD)
References: <2453987.UPN20YN3D3@rogge-hp-probook-6470b>
	 (sfid-20140905_133954_324283_AB82E2CD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-09-05 at 13:39 +0200, Henning Rogge wrote:
> From: "Henning Rogge" <henning.rogge <at> fkie.fraunhofer.de>
> 
> The following patch series adds and implements two new cfg80211_ops that
> allow to query the content of the mac80211s mesh proxy path table via
> netlink.
> 
> v2 changes:
> * split the original patch into separate cfg80211 and mac80211 part

Thanks. You should prefix the subjects with "cfg80211:" and "mac80211:"
respectively, and maybe find shorter ones :)

Also, you forgot to sign off your patches - see "Sign your work" in
https://www.kernel.org/doc/Documentation/SubmittingPatches

johannes

