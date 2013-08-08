Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:37837 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966455Ab3HHXS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 19:18:28 -0400
Received: by mail-qa0-f54.google.com with SMTP id bv4so623882qab.13
        for <linux-wireless@vger.kernel.org>; Thu, 08 Aug 2013 16:18:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1376003573-1243-1-git-send-email-ordex@autistici.org>
References: <1376003573-1243-1-git-send-email-ordex@autistici.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 9 Aug 2013 09:18:07 +1000
Message-ID: <CAGRGNgV0n-nE9UFUiNyYqvgKNzrOE9zMuiRwxJvE5PZ1f6-EFA@mail.gmail.com> (sfid-20130809_011841_993338_5A3B91B4)
Subject: Re: [PATCH] cfg/nl80211: send CMD_INTERFACE event on NETDEV_UNREGISTER
To: Antonio Quartulli <ordex@autistici.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Antonio,

On Fri, Aug 9, 2013 at 9:12 AM, Antonio Quartulli <ordex@autistici.org> wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
>
> Userspace applications may be listening for events (e.g.
> matching mgmt frame) on a given interface. If such interface
> is deleted they would keep hanging because no event will be
> delivered anymore.
>
> Send a CMD_INTERFACE event on NETDEV_UNREGISTER to notify
> userspace that the interface does not exist anymore.
>
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> ---
>  net/wireless/Module.symvers | 118 ++++++++++++++++++++++++++++++++++++++++++++

I'm pretty sure you didn't mean to include this file =)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
