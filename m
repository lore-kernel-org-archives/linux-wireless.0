Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48798 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0KKOO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:14:56 -0500
Date: Thu, 11 Nov 2010 09:12:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Blaise Gassend <blaise@willowgarage.com>
Cc: linville@redhat.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] mac80211_hwsim: Incorporate txpower into rssi
Message-ID: <20101111141239.GA2310@tuxdriver.com>
References: <AANLkTi=t-rEsFKMv-V7Q3cyY6A_+LiBBYW2WbwXzg50b@mail.gmail.com>
 <20101109212422.GE2374@tuxdriver.com>
 <AANLkTi=jZFzwO-uzgyYCrJNrS_M2aNvZ1YuUOnBXz0Ge@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=jZFzwO-uzgyYCrJNrS_M2aNvZ1YuUOnBXz0Ge@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 10:58:37PM -0800, Blaise Gassend wrote:
> > This patch seems to be whitespace-damaged.  Also, you should have a
> > space around the "-" operator.
> 
> Do you need me to recreate the patch?
> 
> > Any comments on this patch from the mac80211_hwsim users?
> 
> To reply to Jouni's comments, I agree that a more complete model of
> RSSI would be nice, but I think that whatever more complete model
> emerges will have txpower as an additive term when determining rssi.
> So this is a step in the right direction. I'm using this to test an
> RSSI-based roaming code, so this little addition serves my purposes
> great for now.
 
I merged the patch yesterday.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
