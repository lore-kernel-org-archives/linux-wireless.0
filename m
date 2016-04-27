Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39098 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753181AbcD0IQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 04:16:26 -0400
Message-ID: <1461744982.13240.75.camel@coelho.fi> (sfid-20160427_101631_082883_61E4F43B)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Date: Wed, 27 Apr 2016 11:16:22 +0300
In-Reply-To: <1461656142-29456-1-git-send-email-johannes@sipsolutions.net>
References: <1461656142-29456-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] wext: remove a/b/g/n from SIOCGIWNAME
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-26 at 09:35 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since a/b/g/n no longer exist as spec amendements and VHT (ex
> 802.11ac)
> wasn't handled at all, it's better to just remove the amendment
> strings
> to avoid confusion.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
