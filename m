Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33377 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbbEYSGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 14:06:11 -0400
Message-ID: <5563648F.106@lwfinger.net> (sfid-20150525_200622_857165_86A77AC2)
Date: Mon, 25 May 2015 13:06:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Shailendra Verma <shailendra.capricorn@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net:wireless - Change 1 to true for bool type variable.
References: <1432576544-3639-1-git-send-email-shailendra.capricorn@gmail.com>
In-Reply-To: <1432576544-3639-1-git-send-email-shailendra.capricorn@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/25/2015 12:55 PM, Shailendra Verma wrote:
> The variable translate is bool type.So assigning true instead of 1.
>
> Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>

When you submit a patch for a particular driver in the drivers/net/wireless/ 
tree, it is preferred that the subject start with the driver name, not with 
net:wireless. Accordingly, your subject should be "ray_cs: Change 1 to true for 
bool type variable". In fact, you can probably choose a better wording for the 
rest of the title, but I do not insist.

Among other advantages, this choice of subject allows easy searches for patches 
for a given driver using 'git log'.

Larry

> ---
>   drivers/net/wireless/ray_cs.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
> index 477f863..0881ba8 100644
> --- a/drivers/net/wireless/ray_cs.c
> +++ b/drivers/net/wireless/ray_cs.c
> @@ -143,7 +143,7 @@ static int psm;
>   static char *essid;
>
>   /* Default to encapsulation unless translation requested */
> -static bool translate = 1;
> +static bool translate = true;
>
>   static int country = USA;
>
>

