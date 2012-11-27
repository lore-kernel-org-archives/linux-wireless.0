Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-1.exch022.serverdata.net ([206.225.164.184]:32103
	"EHLO HUB022-nj-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758039Ab2K0HJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 02:09:43 -0500
Message-ID: <50B46731.4010003@posedge.com> (sfid-20121127_080946_364345_185028D3)
Date: Tue, 27 Nov 2012 12:39:37 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Unable to clone mac80211-next
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FD27514@mbx022-e1-nj-10.exch022.domain.local>
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FD27514@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

Please ignore below error. My bad. I need to use 
git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git

instead of http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git

Thanks,
Mahesh

On 11/27/2012 11:33 AM, Mahesh Palivela wrote:
> Johannes,
>
> I am getting below error when trying to clone mac80211-next git tree.
>
> /work/tmp# git clone http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git
> Cloning into mac80211-next...
> fatal: http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git/info/refs not found: did you run git update-server-info on the server?
> /work/tmp#
>
> Thanks,
> Mahesh
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
