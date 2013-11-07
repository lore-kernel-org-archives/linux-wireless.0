Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0245.hostedemail.com ([216.40.44.245]:36849 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751772Ab3KGAbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 19:31:38 -0500
Message-ID: <1383784301.7940.43.camel@joe-AO722> (sfid-20131107_013140_889960_8E93423E)
Subject: Re: [PATCH 13/13] ath9k: Update MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 16:31:41 -0800
In-Reply-To: <1383783120-22435-14-git-send-email-sujith@msujith.org>
References: <1383783120-22435-1-git-send-email-sujith@msujith.org>
	 <1383783120-22435-14-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-07 at 05:42 +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  MAINTAINERS | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0d59670..a137b3f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1444,17 +1444,6 @@ T:	git git://github.com/kvalo/ath.git
>  S:	Supported
>  F:	drivers/net/wireless/ath/ath6kl/
>  
> -ATHEROS ATH9K WIRELESS DRIVER
> -M:	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
> -M:	Jouni Malinen <jouni@qca.qualcomm.com>
> -M:	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> -M:	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
> -L:	linux-wireless@vger.kernel.org
> -L:	ath9k-devel@lists.ath9k.org
> -W:	http://wireless.kernel.org/en/users/Drivers/ath9k
> -S:	Supported
> -F:	drivers/net/wireless/ath/ath9k/
> -
>  WILOCITY WIL6210 WIRELESS DRIVER
>  M:	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
>  L:	linux-wireless@vger.kernel.org
> @@ -6849,6 +6838,14 @@ T:	git git://linuxtv.org/anttip/media_tree.git
>  S:	Maintained
>  F:	drivers/media/tuners/qt1010*
>  
> +QUALCOMM ATHEROS ATH9K WIRELESS DRIVER
> +M:	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>

While I don't have a problem with this, it's
more common to appoint a single person as a
"lead" maintainer.

> +L:	linux-wireless@vger.kernel.org
> +L:	ath9k-devel@lists.ath9k.org
> +W:	http://wireless.kernel.org/en/users/Drivers/ath9k
> +S:	Supported
> +F:	drivers/net/wireless/ath/ath9k/
> +
>  QUALCOMM ATHEROS ATH10K WIRELESS DRIVER
>  M:	Kalle Valo <kvalo@qca.qualcomm.com>
>  L:	ath10k@lists.infradead.org



