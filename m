Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:36827 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbZLJGUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 01:20:16 -0500
Received: by iwn1 with SMTP id 1so5164563iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 22:20:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1260412981-2982-1-git-send-email-javier@cozybit.com>
References: <1260412981-2982-1-git-send-email-javier@cozybit.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 9 Dec 2009 22:20:03 -0800
Message-ID: <43e72e890912092220k4525d40bn680afece3e8cbb52@mail.gmail.com>
Subject: Re: [PATCH 1/2] mac80211: Fixed bug in mesh portal paths
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>, stable@kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 9, 2009 at 6:43 PM, Javier Cardona <javier@cozybit.com> wrote:
> Paths to mesh portals were being timed out immediately after each use in
> intermediate forwarding nodes.  mppath->exp_time is set to the expiration time
> so assigning it to jiffies was marking the path as expired.
>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Is Cc: stable@kernel.org required or does actually CC'ing
stable@kernel.org in the patch suffice? If the patch has the CC
embedded on the commit log I thought stable team would be notified
upon a merge of the patch. Please correct me if I'm wrong.

Would like to verify as I'm going to be a stable whore now.

  Luis
