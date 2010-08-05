Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53782 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933322Ab0HEOpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 10:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <1281016299-23958-11-git-send-email-andrea.gelmini@gelma.net>
References: <1281016299-23958-1-git-send-email-andrea.gelmini@gelma.net>
	<1281016299-23958-11-git-send-email-andrea.gelmini@gelma.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 5 Aug 2010 16:44:58 +0200
Message-ID: <AANLkTimU7BLxysdKqAZpFLSkNnvM4jCSb-BbUc0RGjAn@mail.gmail.com>
Subject: Re: [PATCH 11/15] net: mac80211: Fix a typo.
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: gelma@gelma.net, Stefano Brivio <stefano.brivio@polimi.it>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Tejun Heo <tj@kernel.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 5, 2010 at 3:51 PM, Andrea Gelmini <andrea.gelmini@gelma.net> wrote:
> "userpace" -> "userspace"
>
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  net/mac80211/rc80211_pid_debugfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/rc80211_pid_debugfs.c b/net/mac80211/rc80211_pid_debugfs.c
> index 47438b4..135f36f 100644
> --- a/net/mac80211/rc80211_pid_debugfs.c
> +++ b/net/mac80211/rc80211_pid_debugfs.c
> @@ -162,7 +162,7 @@ static ssize_t rate_control_pid_events_read(struct file *file, char __user *buf,
>        file_info->next_entry = (file_info->next_entry + 1) %
>                                RC_PID_EVENT_RING_SIZE;
>
> -       /* Print information about the event. Note that userpace needs to
> +       /* Print information about the event. Note that userspace needs to
>         * provide large enough buffers. */
>        length = length < RC_PID_PRINT_BUF_SIZE ?
>                 length : RC_PID_PRINT_BUF_SIZE;

length = min(length, RC_PID_PRINT_BUF_SIZE) maybe? (Though this is not
part of the patch.)

> --
> 1.7.2.1.85.g2d089
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
