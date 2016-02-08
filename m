Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36127 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbcBHWjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 17:39:33 -0500
MIME-Version: 1.0
In-Reply-To: <1454946096-9752-4-git-send-email-jprvita@endlessm.com>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com> <1454946096-9752-4-git-send-email-jprvita@endlessm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 9 Feb 2016 09:39:13 +1100
Message-ID: <CAGRGNgWg3qTCBv5xLrxkyBQksE2vLRkPkX8nf8_5bGR7uusjcQ@mail.gmail.com> (sfid-20160208_233953_496788_21C83A50)
Subject: Re: [PATCH 3/9] rfkill: Point to the correct deprecated doc location
To: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi João,

On Tue, Feb 9, 2016 at 2:41 AM, João Paulo Rechi Vita <jprvita@gmail.com> wrote:
> The "claim" sysfs interface has been removed, so its documentation now
> lives in the "removed" folder.
>
> Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  Documentation/ABI/stable/sysfs-class-rfkill | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/ABI/stable/sysfs-class-rfkill b/Documentation/ABI/stable/sysfs-class-rfkill
> index 097f522..e51571e 100644
> --- a/Documentation/ABI/stable/sysfs-class-rfkill
> +++ b/Documentation/ABI/stable/sysfs-class-rfkill
> @@ -2,8 +2,10 @@ rfkill - radio frequency (RF) connector kill switch support
>
>  For details to this subsystem look at Documentation/rfkill.txt.
>
> -For the deprecated /sys/class/rfkill/*/state and
> -/sys/class/rfkill/*/claim knobs of this interface look in
> +For the deprecated /sys/class/rfkill/*/claim knobs of this interface look in
> +Documentation/ABI/removed/sysfs-class-rfkill.
> +
> +For the deprecated /sys/class/rfkill/*/state knobs of this interface look in
>  Documentation/ABI/obsolete/sysfs-class-rfkill.
>
>  What:          /sys/class/rfkill
> --
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
