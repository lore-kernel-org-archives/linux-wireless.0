Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab3GLL65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 07:58:57 -0400
Message-ID: <1373630329.8205.4.camel@jlt4.sipsolutions.net> (sfid-20130712_135900_231179_C3F4AB9D)
Subject: Re: [PATCH] mac80211: set the forwading in mesh capability info
 accordingly
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Fri, 12 Jul 2013 13:58:49 +0200
In-Reply-To: <1373626522-19486-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130712_130245_676401_F4BDE3E8)
References: <1373626522-19486-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20130712_130245_676401_F4BDE3E8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-12 at 18:55 +0800, Chun-Yeow Yeoh wrote:
> Set the Forwarding bit in Mesh Capability Info according
> to dot11MeshForwarding as defined in IEEE 802.11-2012
> section 8.4.2.100.8.

Applied (with typo in subject fixed)

johannes

