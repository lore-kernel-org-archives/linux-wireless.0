Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:46372 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab3FCOON (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 10:14:13 -0400
Message-ID: <51ACA309.60904@lri.fr> (sfid-20130603_161418_329582_DBE6534B)
Date: Mon, 03 Jun 2013 16:07:05 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Antonio Quartulli <ordex@autistici.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] nl80211: allow sending CMD_FRAME without specifying
 any frequency
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
In-Reply-To: <1370241587-2609-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2013 08:39, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> Users may want to send a frame on the current channel
> without specifying it.
> 
> Make mgmt_tx pass a NULL channel to mac80211 if none has
> been specified by the user.
> 
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> ---
>  net/wireless/nl80211.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 

Have you tested tracing or ath6kl ?
