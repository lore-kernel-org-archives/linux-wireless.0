Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43399 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbZKWTZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 14:25:32 -0500
Received: by ewy19 with SMTP id 19so2192281ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 11:25:38 -0800 (PST)
Message-ID: <4B0AE1AF.9070107@gmail.com>
Date: Mon, 23 Nov 2009 20:25:35 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 5/6] rt2x00: Properly request tx headroom for alignment
 operations.
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com>	 <1258960565-26736-2-git-send-email-gwingerde@gmail.com>	 <1258960565-26736-3-git-send-email-gwingerde@gmail.com>	 <1258960565-26736-4-git-send-email-gwingerde@gmail.com>	 <1258960565-26736-5-git-send-email-gwingerde@gmail.com>	 <1258960565-26736-6-git-send-email-gwingerde@gmail.com> <1258972737.7094.147.camel@johannes.local>
In-Reply-To: <1258972737.7094.147.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/09 11:38, Johannes Berg wrote:
> On Mon, 2009-11-23 at 08:16 +0100, Gertjan van Wingerde wrote:
> 
> This patch would be a LOT easier to read if you didn't do unrelated
> whitespace cleanups.
> 

Well their not really unrelated (they ensure that everything is still properly
lined out when the new member extra_tx_headroom is added), but I can see that
it distracts from the real "meat" of the patch.
I'll see if I can do a preparatory "whitespace cleanup" patch.

---
Gertjan.
