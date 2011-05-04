Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43025 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1EDQcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 12:32:52 -0400
Received: by vxi39 with SMTP id 39so1335048vxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 09:32:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304512025.3563.12.camel@jlt3.sipsolutions.net>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
 <1304467039-7730-2-git-send-email-javier@cozybit.com> <1304512025.3563.12.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 4 May 2011 09:32:32 -0700
Message-ID: <BANLkTi=Xr1z_of+x=_yxxpBB-gwqZJ8-Zw@mail.gmail.com> (sfid-20110504_183255_791909_9470099C)
Subject: Re: [PATCH 01/13] nl80211: Introduce NL80211_MESH_SETUP_USERSPACE_AMPE
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 4, 2011 at 5:27 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-05-03 at 16:57 -0700, Javier Cardona wrote:
>
>> These patches introduce support for Authenticated Mesh Peering Exchange
>> in userspace.  The userspace daemon implements the AMPE protocol and on
>> successfull completion create mesh peers and install encryption keys.
>
> Do all combinations make sense? I mean, I can sort of see that you can
> have authenticated but unsecured, but secured and unauthenticated?

Probably not.  I'm not 100% sure.

Javier
